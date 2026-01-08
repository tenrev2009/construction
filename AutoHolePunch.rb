require 'sketchup.rb'
require 'af_Custom/#HolePunchTool.rb' 

module TIG
  module AutoPuncherSmart
    
    # --- DEDUCTIONS CADRES (Vos réglages) ---
    DOOR_DEDUCTION_WIDTH  = 10.cm  # 2 montants de 5cm
    DOOR_DEDUCTION_HEIGHT = 5.cm   # 1 traverse de 5cm
    
    WINDOW_DEDUCTION_WIDTH  = 0.cm
    WINDOW_DEDUCTION_HEIGHT = 0.cm
    # ----------------------------------------

    @@target_width = nil
    @@target_height = nil

    # Fonction appelée par le bouton de la barre d'outils
    def self.set_target_dimensions(w, h)
      @@target_width = w
      @@target_height = h
    end

    class Watcher < Sketchup::EntitiesObserver
      def onElementAdded(entities, entity)
        return unless entity.valid?
        return unless entity.is_a?(Sketchup::ComponentInstance)
        return unless entity.definition.behavior.cuts_opening?

        # Timer pour laisser le temps au clic de se finir
        UI.start_timer(0.2, false) {
          self.process_entity(entity)
        }
      end

      def process_entity(entity)
        return unless entity.valid?
        return unless entity.glued_to

        model = Sketchup.active_model
        
        # --- 1. APPLICATION DES DIMENSIONS ---
        # On vérifie si des dimensions ont été envoyées par le bouton
        if TIG::AutoPuncherSmart.class_variable_get(:@@target_width)
          
           w_user = TIG::AutoPuncherSmart.class_variable_get(:@@target_width)
           h_user = TIG::AutoPuncherSmart.class_variable_get(:@@target_height)
           
           def_name = entity.definition.name.downcase
           
           # Calculs
           if def_name.include?("porte")
             val_lenx = w_user - DOOR_DEDUCTION_WIDTH
             val_leny = h_user - DOOR_DEDUCTION_HEIGHT
           elsif def_name.include?("fenêtre") || def_name.include?("fenetre")
             val_lenx = w_user - WINDOW_DEDUCTION_WIDTH
             val_leny = h_user - WINDOW_DEDUCTION_HEIGHT
           else
             val_lenx = w_user
             val_leny = h_user
           end

           # Application LenX (Largeur) et LenY (Hauteur pour GlueToAny)
           entity.set_attribute("dynamic_attributes", "lenx", val_lenx.to_f)
           entity.set_attribute("dynamic_attributes", "leny", val_leny.to_f) 
           
           # Force le redessin du composant dynamique
           if defined?($dc_observers)
             $dc_observers.get_latest_class.redraw_with_undo(entity)
           end
           
           # On vide la mémoire pour la prochaine fois
           TIG::AutoPuncherSmart.set_target_dimensions(nil, nil)
           
           # puts "AutoPunch: Dimensions appliquées (#{w_user} x #{h_user})"
        end

        # --- 2. CORRECTION SOL (Z-Fighting) ---
        if entity.transformation.origin.z.abs < 0.5.mm
           vector_up = Geom::Vector3d.new(0, 0, 0.05.mm)
           entity.transform!(vector_up)
        end

        # --- 3. PERCAGE ---
        if entity.get_attribute("HolePunching", "id")
           entity.delete_attribute("HolePunching")
        end

        begin
          model.start_operation("Auto Punch & Size", true)
          TIG::HolePunchTool.new(entity)
          model.commit_operation
        rescue
          model.abort_operation
        end
      end
    end

    class AppWatcher < Sketchup::AppObserver
      def onNewModel(model)
        reset_observer(model)
      end
      def onOpenModel(model)
        reset_observer(model)
      end
      def reset_observer(model)
        model.entities.remove_observer(@obs) if @obs
        @obs = Watcher.new
        model.entities.add_observer(@obs)
      end
    end

    if !file_loaded?(__FILE__)
      watcher = AppWatcher.new
      Sketchup.add_observer(watcher)
      watcher.reset_observer(Sketchup.active_model)
      file_loaded(__FILE__)
      puts "AutoPunchSmart chargé."
    end

  end
end