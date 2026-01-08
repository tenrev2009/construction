# ==============================================================================
#  BARRE D'OUTILS - EXTENSIONS AF
#  Fichier : af_shapestoolbar.rb
# ==============================================================================

require 'sketchup'
require 'af_Custom/mirror_tool.rb'
require 'af_Custom/#HolePunchTool.rb' 

module AF_Extensions
  module AF_shapestoolbar

    # --- VARIABLES GLOBALES DU MODULE ---
    @name = "london"
    @extname = "af_shapestoolbar"
    @extdir = File.dirname(__FILE__)   
    @sfolder = File.join(@extdir, "shapes_ip")
    @ifolder = File.join(@extdir, "icons")      
    @unit = Sketchup.read_default @extname, "unit", "foot"


    # ==========================================================================
    #  SECTION 1 : GESTION DES PORTES (V19)
    # ==========================================================================
    class AutoPunchObserverV19 < Sketchup::InstanceObserver
      def onChange(entity)
        return unless entity.valid? && entity.definition.behavior.cuts_opening?
        UI.stop_timer(@timer) if @timer
        @timer = UI.start_timer(0.6, false) {
            AF_Extensions::AF_shapestoolbar.run_the_protocol(entity)
        }
      end
    end

    def self.run_the_protocol(e)
       return unless e.valid? && e.glued_to
       model = Sketchup.active_model
       model.start_operation("Auto-Update Trou", true, false, true)

       door_bb = e.bounds
       door_diag = door_bb.diagonal
       parent_ents = e.parent.entities
       
       parent_ents.each do |ent|
          next if ent == e
          if ent.is_a?(Sketchup::Group)
             if ent.bounds.intersect(door_bb).valid?
                grp_diag = ent.bounds.diagonal
                if (grp_diag / door_diag) < 1.5
                   ent.erase! if ent.valid?
                end
             end
          end
       end
       
       e.delete_attribute("HolePunching") if e.attribute_dictionary("HolePunching")
       
       lift_vec = Geom::Vector3d.new(0, 0, 2.mm)
       drop_vec = Geom::Vector3d.new(0, 0, -2.mm)
       e.transform!(lift_vec)
       
       if defined?(TIG::HolePunchTool)
          e.definition.invalidate_bounds
          TIG::HolePunchTool.new(e)
          e.transform!(drop_vec)
          new_hole_id = e.get_attribute("HolePunching", "id")
          if new_hole_id
             hole_group = parent_ents.find { |x| x.entityID == new_hole_id }
             hole_group.transform!(drop_vec) if hole_group && hole_group.valid?
          end
       else
          e.transform!(drop_vec)
       end
       model.commit_operation
    end

    def self.attach_observer(entity)
      entity.remove_observer(@last_obs) if @last_obs
      @last_obs = AutoPunchObserverV19.new
      entity.add_observer(@last_obs)
    end

    def self.activate_on_selection
      count = 0
      Sketchup.active_model.selection.each do |e|
         if e.is_a?(Sketchup::ComponentInstance)
            self.attach_observer(e)
            self.run_the_protocol(e)
            count += 1
         end
      end
      UI.messagebox("Activé sur #{count} porte(s).")
    end


    # ==========================================================================
    #  SECTION 2 : CONSTRUCTION INTELLIGENTE (CORRECTIF TRAITS)
    # ==========================================================================

    class SmartRoomBuilder
      
      def self.main
        model = Sketchup.active_model
        sel = model.selection
        layers = model.layers
        
        # --- ETAPE 0 : PREPARATION CALQUES ---
        lay_wall = layers.add("Murs")
        lay_floor = layers.add("Sol")
        lay_ceil = layers.add("Plafond")
        lay_cons = layers.add("Traits Construction")
        
        edges = sel.grep(Sketchup::Edge)
        if edges.empty?
          UI.messagebox("Sélectionnez le tracé au sol.")
          return
        end

        prompts = ["Épaisseur des Murs (cm)", "Hauteur sous Plafond (cm)", "Épaisseur Dalles (cm)"]
        defaults = [20.0, 250.0, 20.0]
        input = UI.inputbox(prompts, defaults, "Construction Pièce")
        return unless input

        wall_thick = input[0].to_f.cm
        wall_height = input[1].to_f.cm
        slab_thick = input[2].to_f.cm

        model.start_operation("Construction Pièce", true)

        # Conteneur temporaire
        container_group = model.active_entities.add_group
        container_group.name = "TEMP_CONTAINER"
        ents = container_group.entities

        # Copie des arêtes pour calcul
        path_edges = []
        edges.each do |e|
            p1 = e.start.position
            p2 = e.end.position
            path_edges << ents.add_line(p1, p2)
        end
        
        # Identification de la face intérieure
        floor_face = nil
        path_edges[0].find_faces
        path_edges.each do |e|
            if e.faces.length > 0
               floor_face = e.faces[0]
               break
            end
        end

        if floor_face
            if floor_face.normal.z < 0
               floor_face.reverse!
            end
            
            inner_points = floor_face.vertices.collect{|v| v.position}

            # ===============================================================
            # 1. CREATION DES MURS
            # ===============================================================
            wall_group = ents.add_group
            wall_group.name = "Murs"
            wall_group.layer = lay_wall
            
            w_ents = wall_group.entities
            w_path = []
            
            # Points ordonnés pour le chemin
            points = floor_face.outer_loop.vertices.collect{|v| v.position}
            points << points[0] if points[0] != points.last
            
            (0..points.length-2).each do |i|
               w_path << w_ents.add_line(points[i], points[i+1])
            end

            vec_segment = points[1] - points[0]
            perpendicular = vec_segment * Geom::Vector3d.new(0,0,1)
            test_point = points[0].offset(perpendicular, 0.1.mm)
            result = floor_face.classify_point(test_point)
            if result != Sketchup::Face::PointOutside
               perpendicular.reverse!
            end

            pt_start = points[0]
            pt_width = pt_start.offset(perpendicular, wall_thick)
            pt_top_start = pt_start.offset([0,0,1], wall_height)
            pt_top_width = pt_width.offset([0,0,1], wall_height)

            profile_face = w_ents.add_face(pt_start, pt_width, pt_top_width, pt_top_start)
            profile_face.followme(w_path)
            
            # ===============================================================
            # 2. CAPTURE DE L'EMPREINTE
            # ===============================================================
            wall_footprints = []
            wall_group.entities.grep(Sketchup::Face).each do |f|
                if f.normal.parallel?(Z_AXIS) && f.bounds.center.z.abs < 0.1.cm
                   wall_footprints << f.outer_loop.vertices.collect{|v| v.position}
                end
            end

            # ===============================================================
            # 3. CREATION DU SOL (VERS LE BAS)
            # ===============================================================
            floor_group = ents.add_group
            floor_group.name = "Sol"
            floor_group.layer = lay_floor
            
            f_inner = floor_group.entities.add_face(inner_points)
            f_inner.reverse! if f_inner && f_inner.normal.z < 0
            
            wall_footprints.each do |pts|
                f_w = floor_group.entities.add_face(pts)
                f_w.reverse! if f_w && f_w.normal.z < 0
            end
            
            floor_group.entities.grep(Sketchup::Edge).each do |e|
                e.erase! if e.valid? && e.faces.length > 1
            end
            
            floor_group.entities.grep(Sketchup::Face).each do |f|
                f.pushpull(-slab_thick)
            end

            # ===============================================================
            # 4. CREATION DU PLAFOND (AU DESSUS DES MURS)
            # ===============================================================
            ceil_group = ents.add_group
            ceil_group.name = "Plafond"
            ceil_group.layer = lay_ceil
            
            ceil_group.entities.add_face(inner_points)
            wall_footprints.each { |pts| ceil_group.entities.add_face(pts) }
            
            ceil_group.entities.grep(Sketchup::Edge).each do |e|
                e.erase! if e.valid? && e.faces.length > 1
            end
            
            tr_up = Geom::Transformation.new([0,0,wall_height])
            ceil_group.entities.transform_entities(tr_up, ceil_group.entities.to_a)
            
            ceil_group.entities.grep(Sketchup::Face).each do |f|
                f.reverse! if f.normal.z < 0 
                f.pushpull(slab_thick)
            end

            # ===============================================================
            # 5. GESTION DES TRAITS DE CONSTRUCTION (CORRIGÉ)
            # ===============================================================
            # On crée ce groupe DANS le contexte actif (pas dans le conteneur qui va exploser)
            cons_group = model.active_entities.add_group
            cons_group.name = "Traits de Construction"
            cons_group.layer = lay_cons
            
            # On redessine proprement le chemin calculé (points)
            # Cela évite les bugs de décalage ou de duplication d'arêtes
            (0..points.length-2).each do |i|
               cons_group.entities.add_line(points[i], points[i+1])
            end

            # Nettoyage interne
            ents.grep(Sketchup::Face).each { |f| f.erase! if f.valid? }
            path_edges.each {|e| e.erase! if e.valid?}

        else
            UI.messagebox("Erreur : Surface non fermée.")
            model.abort_operation
            return
        end

        # --- ETAPE FINALE : LIBÉRATION ---
        container_group.explode

        model.commit_operation
      end
    end


    # ==========================================================================
    #  SECTION 3 : OUTILS
    # ==========================================================================

    def self.place_me(name)
      mod = Sketchup.active_model
      skp = File.join(@sfolder, name+".skp")
      dname = name+"-"+@unit
      if !mod.definitions[dname]
          case @unit
          when "inch" then scale = 1.0 / 12
          when "mm" then scale = 1.0 / 12 / 2.54 / 10
          when "cm" then scale = 1.0 / 12 / 2.54
          when "m" then scale = 1.0 / 12 / 2.54 * 100
          else scale = 1.0
          end
          t = Geom::Transformation.new scale           
          defs = mod.definitions
          d = defs.load skp
          d.name = dname
          ents = []
          d.entities.each { |e| ents.push e }
          d.entities.transform_entities(t,ents)
      end
      c = mod.definitions[dname]
      inst = mod.place_component c, true
      self.attach_observer(inst) if inst 
    end

    def self.select_unit; dlg = UI::WebDialog.new("Aide", true,"ShowSketchupDotCom", 739, 641, 150, 150, true); dlg.set_url ""; dlg.show; end
    def self.select_unia; Sketchup.send_action 10502; Sketchup.send_action 10519; end
    def self.clica; Sketchup.send_action "selectScaleTool:"; end
    def self.options; $dc_observers.get_latest_class.show_configure_dialog; Sketchup.send_action("selectSelectionTool:"); end
    def self.click; Sketchup.active_model.select_tool(DCInteractTool.new($dc_observers)); end
    
    class Hideedge
      def initialize; @ip = Sketchup::InputPoint.new; @cursor = 645; end
      def onLButtonDown(flags, x, y, view); @ip.pick(view,x,y); if @ip.edge; Sketchup.active_model.start_operation 'Hide'; @ip.edge.hidden = true; Sketchup.active_model.commit_operation; end; end
    end

    if !file_loaded?(__FILE__)
      
      UI.add_context_menu_handler do |context_menu|
        if !Sketchup.active_model.selection.empty?
           context_menu.add_item("Activer Auto-Perçage (V19)") { self.activate_on_selection }
        end
      end

      menu = UI.menu("Draw").add_submenu(@name)
      toolbar = UI::Toolbar.new @name    
      
      shapes = [ "ouverture" , "porte" , "portedouble" , "fenêtre_store" , "fenêtre" ,]
      shapes.each { |s|
        cmd = UI::Command.new(s.capitalize) { self.place_me(s) }
        cmd.small_icon = File.join(@ifolder, s + "_l.png"); cmd.large_icon = File.join(@ifolder, s + "_l.png")
        menu.add_item cmd; toolbar.add_item cmd    
      }
      menu.add_separator; toolbar.add_separator
      
      s = "Paramètres"; cmd = UI::Command.new(s) { self.options }; cmd.small_icon = File.join(@ifolder, "add_l.png"); cmd.large_icon = File.join(@ifolder, "add_l.png"); menu.add_item cmd; toolbar.add_item cmd
      s = "Echelle"; cmd = UI::Command.new(s) { self.clica }; cmd.small_icon = File.join(@ifolder, "add7_l.png"); cmd.large_icon = File.join(@ifolder, "add7_l.png"); menu.add_item cmd; toolbar.add_item cmd
      s = "Interaction"; cmd = UI::Command.new(s) { self.click }; cmd.small_icon = File.join(@ifolder, "add5_l.png"); cmd.large_icon = File.join(@ifolder, "add5_l.png"); menu.add_item cmd; toolbar.add_item cmd
      toolbar.add_separator          
      
      s = "Créer Pièce (Mur+Sol+Plafond)"
      cmd = UI::Command.new(s) { SmartRoomBuilder.main }
      cmd.small_icon = File.join(@ifolder, "add8_l.png"); cmd.large_icon = File.join(@ifolder, "add8_l.png")
      cmd.tooltip = "Sélectionnez le tracé au sol et cliquez"; cmd.status_bar_text = "Génère Murs, Sol et Plafond"
      menu.add_item cmd; toolbar.add_item cmd
      
      s = "Ouverture multi"; cmd = UI::Command.new(s) { Sketchup.active_model.select_tool BST_HoleOnSolid.new( true ) }; cmd.small_icon = File.join(@ifolder, "add4_l.png"); cmd.large_icon = File.join(@ifolder, "add4_l.png"); menu.add_item cmd; toolbar.add_item cmd
      toolbar.add_separator
      s = "Masquage"; cmd = UI::Command.new(s) { Sketchup.active_model.select_tool Hideedge.new }; cmd.small_icon = File.join(@ifolder, "add9_l.png"); cmd.large_icon = File.join(@ifolder, "add9_l.png"); menu.add_item cmd; toolbar.add_item cmd
      s = "Elevation"; cmd = UI::Command.new(s) { self.select_unia }; cmd.small_icon = File.join(@ifolder, "add6_l.png"); cmd.large_icon = File.join(@ifolder, "add6_l.png"); menu.add_item cmd; toolbar.add_item cmd

      if defined?(AF_Extensions::MirrorTool)
          s = "Miroir"; cmd = UI::Command.new(s) { Sketchup.active_model.select_tool(AF_Extensions::MirrorTool.new) }; cmd.small_icon = File.join(@ifolder, "mirror_sm.png"); cmd.large_icon = File.join(@ifolder, "mirror_l.png"); menu.add_item cmd; toolbar.add_item cmd
      end

      toolbar.show
      file_loaded(__FILE__)
    end 
  end 
end