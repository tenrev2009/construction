# =====================
# Main file for Place Shapes Toolbar
# =====================


require 'sketchup'


# =====================


module AF_Extensions

  module AF_shapestoolbar


    # =====================

  
    # General variables
    @name = "london"
    @extname = "af_shapestoolbar"
    
    @extdir = File.dirname(__FILE__)   
    @sfolder = File.join(@extdir, "shapes_ip")
    @ifolder = File.join(@extdir, "icons")    
  
    # Set base unit for shapes from stored value
    @unit = Sketchup.read_default @extname, "unit", "foot"

    # @skps = Dir.entries(@sfolder)
    # UI.messagebox @skps


    # =====================

    
    def self.place_me(name)
      
      # Definition file to load
      mod = Sketchup.active_model
      skp = File.join(@sfolder, name+".skp")
      
      # Load defnition and scale it
      dname = name+"-"+@unit
      
      if !mod.definitions[dname]
      
          # Scaling factor based on unit
          case @unit
          when "inch"
            scale = 1.0 / 12
          when "mm"
            scale = 1.0 / 12 / 2.54 / 10
          when "cm"
            scale = 1.0 / 12 / 2.54
          when "m"
            scale = 1.0 / 12 / 2.54 * 100
          else
            scale = 1.0
          end
          t = Geom::Transformation.new scale          
          
          # Load definition and give it unit-based name
          defs = mod.definitions
          d = defs.load skp
          d.name = dname
          
          # Scale definition entities accordingly
          ents = []
          d.entities.each { |e|
            ents.push e
          }
          d.entities.transform_entities(t,ents)
          
      end
      
      c = mod.definitions[dname]
      i = mod.place_component c, true
    
    end


    # =====================


    def self.select_unit
    
     dlg = UI::WebDialog.new("aide/mise à jour", true,"ShowSketchupDotCom", 739, 641, 150, 150, true);
	 dlg.set_url ""
	 dlg.show

    end
    

    #=============Fenêtre de visualisation==================
	
	def self.select_unia
    Sketchup.send_action 10502;Sketchup.send_action 10519
    
	
	

	#--------------------------------------------------------------------------------------------------
	
	end
	
	
	# =============Object stretching===============
  def self.clica
	  result = Sketchup.send_action "selectScaleTool:"
	  end
  # ============================
    def self.show_help
    # Show the website as an About dialog
    
      dlg = UI::WebDialog.new(@name+' - Tutorial / Description', true,'af_shapestoolbar_aide', 1100, 800, 150, 150, true)
      dlg.set_url('')
      dlg.show
      
    end # show_help


	
	#******************************Sliding hidden Début*******************************************
	
	#=begin rdoc
#auteur：dota_
#Version：1.0
#Nom：Sliding hidden
#=end

#module SU::Powertools

	### MENU & TOOLBARS ### --------------------------------------------------

	#unless file_loaded?( __FILE__ )      
	#	cmd_Hideedge = UI::Command.new('Sliding hidden') { Sketchup.active_model.select_tool Hideedge.new }
	#	cmd_Hideedge.large_icon = 'Images/Hideedge_24.png'
	#	cmd_Hideedge.small_icon = 'Images/Hideedge_16.png'
	#	cmd_Hideedge.status_bar_text = 'Maintenez le bouton gauche de la souris enfoncé pour activer, masquer le bord survolé par la souris.'
	#	cmd_Hideedge.tooltip = 'Sliding hidden'

	#	# Menu
	#	@menu.add_item( cmd_Hideedge )
	#	#@menu.add_separator

	#	# Toolbar
	#	@toolbar.add_item( cmd_Hideedge )
	#	#@toolbar.add_separator
	#end # UI
	#file_loaded( __FILE__ )
  
  
	### METHODS ### ----------------------------------------------------------
	class Hideedge

	def initialize
		@ip = Sketchup::InputPoint.new
		@cursor = 645 #erase
		@buttondown = false
	end

	def reset
		@ip.clear
		Sketchup.set_status_text "Maintenez le bouton gauche de la souris enfoncé pour activer, masquer le bord survolé par la souris."
	end

	def activate
		self.reset
	end

	def onMouseMove(flags, x, y, view)
		@ip.pick(view,x,y)
		if (@buttondown)
			if (@ip.edge)
				hide_edge (@ip.edge)
				
			end
		end
	end

	def onSetCursor
		UI.set_cursor(@cursor)
	end

	def onLButtonDown(flags, x, y, view)
		@buttondown = true
		@ip.pick(view,x,y)
		if (@ip.edge)
			hide_edge (@ip.edge)
			puts "Hidden an edge"
		end
	end

	def onLButtonUp(flags, x, y, view)
		@buttondown = false
	end

	def hide_edge (edge)
		Sketchup.active_model.start_operation 'Sliding hidden'
		if (edge.curve)
			edge.curve.each_edge {|e| e.hidden = true}
			puts "cacher une courbe"
		else
			edge.hidden = true
			puts "cacher un segment"
		end
		Sketchup.active_model.commit_operation 
	end

	end
  
#end # module
	#******************************Sliding hidden fin*******************************************
	
	#******************************la construction du mur  commence*******************************************
	
	
	
	### MENU & TOOLBARS ### --------------------------------------------------

	#unless file_loaded?( __FILE__ )      
	#	cmd_ExtrudeAlongPath = UI::Command.new('Squeeze rectangle') { ExtrudeAlongPath.main }
	#	cmd_ExtrudeAlongPath.large_icon = 'Images/ExtrudeAlongPath_24.png'
	#	cmd_ExtrudeAlongPath.small_icon = 'Images/ExtrudeAlongPath_16.png'
	#	cmd_ExtrudeAlongPath.status_bar_text = 'Squeeze the rectangle along the path。'
	#	cmd_ExtrudeAlongPath.tooltip = 'Squeeze the rectangle along the path'

		# Menu
		#@menu.add_item( cmd_ExtrudeAlongPath )
		#@menu.add_separator

		# Toolbar
		#@toolbar.add_item( cmd_ExtrudeAlongPath )
		#@toolbar.add_separator
	#end # UI
	#file_loaded( __FILE__ )
  
  
	### METHODS ### ----------------------------------------------------------
	class ExtrudeAlongPath
		def self.main

		@error=0 ### 17/8/5 ###
		model = Sketchup.active_model
			
		begin
			model.start_operation("positionne le rectangle le long du chemin", true)
		rescue
			model.start_operation("positionne le rectangle le long du chemin")
		end

		entities = model.active_entities
		ss = model.selection

		if ss.empty?
		  UI.messagebox("pas de chemin selectionné  !")
		  return nil
		end
		### #################################################################

		def self.get_vertices

		### this next bit is mainly thanks to Rick Wilson's weld.rb ###

			model=Sketchup.active_model
			ents=model.active_entities
			@sel=model.selection
			sl=@sel.length
			verts=[]
			edges=[]
			@newVerts=[]
			startEdge=startVert=nil

		#DELETE NON-EDGES, GET THE VERTICES

			@sel.each {|item| edges.push(item) if item.typename=="Edge"}
			edges.each {|edge| verts.push(edge.vertices)}
			verts.flatten!

		#FIND AN END VERTEX

			vertsShort=[]
			vertsLong=[]
			vertsEnds=[] ### 17/8/5 ### to ensure array is only ends ###
			verts.each do |v|
				if vertsLong.include?(v)
					vertsShort.push(v)
				else
					vertsLong.push(v)
				end
			end
			vertsLong.each do |v| ### 17/8/5 ### to ensure array is only ends ###
				if not vertsShort.include?(v)
					vertsEnds.push(v)
				end
			end ### 17/8/5 ### to ensure array is only ends ###
			if vertsEnds.length==0 ### i.e. it's looped ###
				### path start or end ? ### 17/8/5 ###
				if @theEnd==0
				  startVert=vertsLong.first
				  startEdge=startVert.edges.first
				else
				  startVert=vertsLong.last
				  startEdge=startVert.edges.first
				end
				###
				closed=true
			else
				if vertsEnds.length != 2
					UI.messagebox("Le chemin sélectionné a une discontinuité! \\ Impossible de travailler! \\ Veuillez resélectionner un seul chemin continu ... ") ### 17/8/5 ###
					@error=1
					return nil
				else
					### path start or end ? ### 17/8/5 ###
					if @theEnd==0
					  startVert=vertsEnds.first
					else
					  startVert=vertsEnds.last
					end
					###
					closed=false
					startEdge=startVert.edges.first
				end
			end
			@sel.clear


		#SORT VERTICES, LIMITING TO THOSE IN THE SELECTION SET

			if startVert==startEdge.start
				@newVerts=[startVert]
				counter=0
				while @newVerts.length < verts.length
					edges.each do |edge|
						if edge.end==@newVerts.last
							@newVerts.push(edge.start)
						elsif edge.start==@newVerts.last
							@newVerts.push(edge.end)
						end
					end
					counter+=1
					if counter > verts.length
						return nil if UI.messagebox("Il semble que quelque chose s'est mal passé, voulez-vous réessayer ? ", MB_YESNO)!=6
						@newVerts.reverse!
						reversed=true
					end
				end
			else
				@newVerts=[startVert]
				counter=0
				while @newVerts.length < verts.length
					edges.each do |edge|
						if edge.end==@newVerts.last
							@newVerts.push(edge.start)
						elsif edge.start==@newVerts.last
							@newVerts.push(edge.end)
						end
					end
					counter+=1
					if counter > verts.length
						return nil if UI.messagebox("Il semble que quelque chose s'est mal passé, voulez-vous réessayer ? ", MB_YESNO)!=6
						@newVerts.reverse!
						reversed=true
					end
				end
			end
			@newVerts.reverse! if reversed

		#CONVERT VERTICES TO POINT3Ds

			@newVerts.collect!{|x| x.position}

		### now have an array of vertices in order with NO forced closed loop ...

		end ### get_vertices

		### near or far ?
		@theEnd=0
		get_vertices
		if @error==1
		  return nil
		end

		### dialog #################################################################

		alignments = ["point","axe","interieur-exterieur","axe(milieu)"]
		enums = [alignments.join("|")]
		prompts = ["Alignement: ","Largeur: ","Hauteur: "]

		if not @widthIn
		   values = ["axe",50.mm,50.mm]
		else
		   values = [@alignment,@widthIn,@heightInfirst]
		end

		results = inputbox prompts, values, enums, "parameter settings"

		return nil if not results ### i.e. the user cancelled the operation

		@alignment,@widthIn,@heightInfirst = results

		@heightIn = @heightInfirst

		### #################################################################

		### #################################################################

		### restore selection set of edges and display them
		def self.edge_reselector (xnewVerts)
		 model = Sketchup.active_model
		 ents=model.active_entities
		 theEdgeX = []
		 0.upto(xnewVerts.length-2) do |i| ### 1/8/5
		   theEdgeX[i] = ents.add_line(xnewVerts[i],xnewVerts[i+1])  ### make vertices into edges
		 end
		 model.selection.clear
		 model.selection.add theEdgeX
		end
		###def


		### do main stuff #################################################################

		pt1 = @newVerts[0]
		pt2 = @newVerts[1]

		width = @widthIn
		if @widthIn == 0.mm ### can't be 0 ###
		   @widthIn = 100.mm
		   edge_reselector(@newVerts)
		   UI.messagebox("la largeur ne peut être 0")
		   return nil
		end
		###
		if @heightIn == 0.mm ### can't be 0 ###
		   @heightIn = @widthIn
		end
		###
		if (pt1.x == pt2.x) and (pt1.y == pt2.y) ### vertical 1st path ###
		   vflag = 1
		   height = @heightIn
		else
		   vflag = 0
		   height = ((@heightIn * (pt1.distance pt2)) / (pt1.distance [pt2.x,pt2.y,pt1.z]))
		end
		###
		if @alignment == "point"
		   offL = width
		   offR = 0
		   heightUp = height
		   heightDn = 0
		   cpatt = "__" ### 17/8/5 ###
		end
		if @alignment == "axe"
		   offL = width / 2
		   offR = width / 2
		   heightUp = height
		   heightDn = 0
		   cpatt = "." ### 17/8/5 ###
		end
		if @alignment == "interieur-exterieur"
		   offL = width
		   offR = 0
		   heightUp = height 
		   heightDn = 0
		   cpatt = "_" ### 17/8/5 ###
		end
		if @alignment == "axe(milieu)"
		   offL = width / 2
		   offR = width / 2
		   heightUp = height / 2
		   heightDn = height / 2
		   cpatt = "-.-" ### 17/8/5 ###
		end
		### #################################################################

		if vflag == 1 ### vertical ### 7/8/5
		  vec = pt1.vector_to [(pt1.x + 1), pt1.y, pt1.z]
		else
		  vec = pt1.vector_to [pt2.x, pt2.y, pt1.z]
		end

		### #################################################################

		piBy2 = 1.5707963267948965 ### a radian right-angle for calculating vector offset to edges

		rotated_vecL = vec.transform(Geom::Transformation.rotation(pt1, [0,0,1], (0 + piBy2))) ### 7/8/5
		pt1_leftC = pt1.offset(rotated_vecL, offL)
		rotated_vecR = vec.transform(Geom::Transformation.rotation(pt1, [0,0,1], (0 - piBy2))) ### 7/8/5
		pt1_rightC = pt1.offset(rotated_vecR, offR)

		if vflag == 1 ### 1st path is vertical ### 7/8/5
		  pt1_left  = pt1_leftC.offset([-1,0,0], heightDn)
		  pt1_right = pt1_rightC.offset([-1,0,0], heightDn)
		  pt2_left  = pt1_leftC.offset([1,0,0], heightUp)
		  pt2_right = pt1_rightC.offset([1,0,0], heightUp)
		else
		  pt1_left  = pt1_leftC.offset([0,0,-1], heightDn)
		  pt1_right = pt1_rightC.offset([0,0,-1], heightDn)
		  pt2_left  = pt1_leftC.offset([0,0,1], heightUp)
		  pt2_right = pt1_rightC.offset([0,0,1], heightUp)
		end

		###

		ents=entities

		### #################################################################
		### add construction line along first vector ### 7/8/5
		cline1 = ents.add_cline(pt1,pt2)
		cline1.end=nil
		cline1.start=nil
		cline1.stipple=cpatt ### 17/8/5 ###


		### group the extrusion... ### 7/8/5 #################################################################

		group=entities.add_group
		entities=group.entities

		theFace = entities.add_face(pt1_right, pt1_left, pt2_left, pt2_right) ### 7/8/5

		if vflag == 1 and height > 0
		   theFace.reverse!
		end
		if vflag == 1 and width < 0
		   theFace.reverse!
		end
		if vflag == 1 and pt1.z > pt2.z
		   theFace.reverse!
		end

		### check start /end of path ###
		keypress = 6 ### = YES
		### ask if face starts at correct side ? ### 17/8/5 ###
		model.selection.clear
		model.selection.add [theFace]
		model.selection.add [theFace.edges]
		###
		if @alignment == "center" || @alignment == "axe"
			keypress = 6
		else
			keypress = UI.messagebox("commencez à cette extrémité ?", MB_YESNO) ###
		end
		if keypress != 6
		  ### get rid of old stuff first ###
		  entities.erase_entities cline1
		  entities.erase_entities model.selection
		  edge_reselector(@newVerts)
		  @theEnd=1
		  get_vertices
		  ###
		  pt1 = @newVerts[0]
		  pt2 = @newVerts[1]
		  if (pt1.x == pt2.x) and (pt1.y == pt2.y) ### vertical 1st path ###
			 vflag = 1
			 height = @heightIn
		  else
			 vflag = 0
			 height = ((@heightIn * (pt1.distance pt2)) / (pt1.distance [pt2.x,pt2.y,pt1.z]))
		  end
		  if vflag == 1 ### vertical ### 7/8/5
			vec = pt1.vector_to [(pt1.x + 1), pt1.y, pt1.z]
		  else
			vec = pt1.vector_to [pt2.x, pt2.y, pt1.z]
		  end
		  rotated_vecL = vec.transform(Geom::Transformation.rotation(pt1, [0,0,1], (0 + piBy2))) ### 7/8/5
		  pt1_leftC = pt1.offset(rotated_vecL, offL)
		  rotated_vecR = vec.transform(Geom::Transformation.rotation(pt1, [0,0,1], (0 - piBy2))) ### 7/8/5
		  pt1_rightC = pt1.offset(rotated_vecR, offR)
		  if vflag == 1 ### 1st path is vertical ### 7/8/5
			pt1_left  = pt1_leftC.offset([-1,0,0], heightDn)
			pt1_right = pt1_rightC.offset([-1,0,0], heightDn)
			pt2_left  = pt1_leftC.offset([1,0,0], heightUp)
			pt2_right = pt1_rightC.offset([1,0,0], heightUp)
		  else
			pt1_left  = pt1_leftC.offset([0,0,-1], heightDn)
			pt1_right = pt1_rightC.offset([0,0,-1], heightDn)
			pt2_left  = pt1_leftC.offset([0,0,1], heightUp)
			pt2_right = pt1_rightC.offset([0,0,1], heightUp)
		  end
		  ### add NEW construction line along NEW first vector ### 17/8/5
		  cline1 = ents.add_cline(pt1,pt2)
		  cline1.end=nil
		  cline1.start=nil
		  cline1.stipple=cpatt
		  ###
		  theFace = entities.add_face(pt1_right, pt1_left, pt2_left, pt2_right) ###
		if vflag == 1 and height > 0
		   theFace.reverse!
		end
		if vflag == 1 and width < 0
		   theFace.reverse!
		end
		if vflag == 1 and pt1.z > pt2.z
		   theFace.reverse!
		end

		end
		### end sorting start / end of path ### 17/8/5 ###


		###
		### ask if face starts at correct side ? ### 7/8/5
		if @alignment == "edge" or  @alignment == "extero"
		  model.selection.clear
		  model.selection.add [theFace]
		  model.selection.add [theFace.edges]
		end

		### if NO then reverse face side ### 7/8/5

		### #################################################################

		@@theEdges= []
		  0.upto(@newVerts.length-2) do |i| ### 1/8/5
		  @@theEdges[i] = ents.add_line(@newVerts[i],@newVerts[i+1]) ### make vertices into edges
		end

		### follow me along selected edges

		if height > 0
		  if width > 0
			theExtrusion=theFace.reverse!.followme @@theEdges ###
		  end
		  if width < 0
			theExtrusion=theFace.followme @@theEdges ###
		  end
		end
		if height < 0
		  if width > 0
			theExtrusion=theFace.followme @@theEdges ###
		  end
		  if width < 0
			theExtrusion=theFace.reverse!.followme @@theEdges ###
		  end
		end

		###
		if not theExtrusion
		  UI.messagebox("Impossible de construire ! \\ Le chemin sélectionné peut avoir une intersection ou une rupture ! \\ neuillez resélectionner un seul chemin continu ... ")
		  entities.erase_entities theFace.edges
		  entities.erase_entities cline1
		  edge_reselector(@newVerts)
		  return nil
		end
		###
		entities.erase_entities cline1
		model.commit_operation

		### #################################################################
		### restore selection set of edges and display them
		edge_reselector(@newVerts)


		end ### end def
	end

	
	
	
	#************************************************Fin de construction du mur *****************************************************************
	
	
	
	
	# =====================Options du composant
    
    
	def self.options
	  if $dc_observers.get_latest_class.configure_dialog_is_visible
	  $dc_observers.get_latest_class.close_configure_dialog
	  else
	  $dc_observers.get_latest_class.show_configure_dialog
	  end
	  Sketchup.send_action("selectSelectionTool:")
	  end
	
	# ======================
	
	def self.click
	  Sketchup.active_model.select_tool(DCInteractTool.new($dc_observers))
	  end
	
	#=========================
    
    # Load extension at startup and add menu items
    if !file_loaded?(__FILE__)
    
      # Add to the Draw menu and create a toolbar    
      menu = UI.menu("Draw").add_submenu(@name)
      toolbar = UI::Toolbar.new @name    
      
      # All shapes to load in this order
      shapes = [ "ouverture" , "porte" , "portedouble" , "fenêtre_store" , "fenêtre" ,]
      
      # Add them all to menu and toolbar
      shapes.each { |s|
      
        cmd = UI::Command.new(s.capitalize) { self.place_me(s) }
        cmd.small_icon = File.join(@ifolder, s + "_l.png")
        cmd.large_icon = File.join(@ifolder, s + "_l.png")
        cmd.tooltip = s.capitalize
        cmd.status_bar_text = "charger " + s + " (et appliquer)"
        menu.add_item cmd
        toolbar.add_item cmd    
      
      }
      
      menu.add_separator
      toolbar.add_separator
      #************* Options du composant
	  
	  
	  
	  #*******************Object stretching**********************
	  
	  s = "panneau de paramètres"
      cmd = UI::Command.new(s.capitalize) { self.options }
      cmd.small_icon = File.join(@ifolder, "add_l.png")
      cmd.large_icon = File.join(@ifolder, "add_l.png")
      cmd.tooltip = s.capitalize
      cmd.status_bar_text = "ajuster les paramètres / changer les parametres"
      menu.add_item cmd
      toolbar.add_item cmd
	  
	  #*******************Object stretching**********************
	  s = "redimensionne les  objets	"
      cmd = UI::Command.new(s.capitalize) { self.clica }
      cmd.small_icon = File.join(@ifolder, "add7_l.png")
      cmd.large_icon = File.join(@ifolder, "add7_l.png")
      cmd.tooltip = s.capitalize
      cmd.status_bar_text = "redimensionner le composant/ajuster le composant"
      menu.add_item cmd
      toolbar.add_item cmd
	  ##-------------toolbar.add_separator         #**************Ligne de séparation d'icônes
	  #*******************Object stretching**********************
	  #*******************Interaction**********************
	  
	  s = "outil d'interaction"
      cmd = UI::Command.new(s.capitalize) { self.click }
      cmd.small_icon = File.join(@ifolder, "add5_l.png")
      cmd.large_icon = File.join(@ifolder, "add5_l.png")
      cmd.tooltip = s.capitalize
      cmd.status_bar_text = "outil d'interaction"
      menu.add_item cmd
      toolbar.add_item cmd
	  toolbar.add_separator         
	  
	  #**************Ligne de séparation d'icônes
	  #*******************Interaction**********************
	  
	  #******************************************
	  
	  s = "construction mur"
      cmd = UI::Command.new(s.capitalize) { ExtrudeAlongPath.main }
      cmd.small_icon = File.join(@ifolder, "add8_l.png")
      cmd.large_icon = File.join(@ifolder, "add8_l.png")
      cmd.tooltip = s.capitalize
      cmd.status_bar_text = "cliquez sur la ligne définissant le chemin du mur pour le construire"
      menu.add_item cmd
      toolbar.add_item cmd
	  
	  #*******************Path painting wall**********************
	  
	  #*******************Ouverture**********************
	  s = "percer l'ouverture"
      cmd = UI::Command.new(s.capitalize) { TIG::HolePunchTool.new() }
      cmd.small_icon = File.join(@ifolder, "add3_l.png")
      cmd.large_icon = File.join(@ifolder, "add3_l.png")
      cmd.tooltip = s.capitalize
      cmd.status_bar_text = "création de l'ouverture"
      menu.add_item cmd
      toolbar.add_item cmd
	  
	  #*********************Ouverture********************
      
	  s = "Ouverture multi-épaisseur"
      cmd = UI::Command.new(s.capitalize) { Sketchup.active_model.select_tool BST_HoleOnSolid.new( true ) }
      cmd.small_icon = File.join(@ifolder, "add4_l.png")
      cmd.large_icon = File.join(@ifolder, "add4_l.png")
      cmd.tooltip = s.capitalize
      cmd.status_bar_text = "Ouverture multi-panneaux"
      menu.add_item cmd
      toolbar.add_item cmd
	  toolbar.add_separator         #**************Ligne de séparation d'icônes
	  #*********************Ouverture********************
	  #
	  #*********************Sliding hidden********************
	  
	  s = "masquage des lignes"
      cmd = UI::Command.new(s.capitalize) { Sketchup.active_model.select_tool Hideedge.new }
      cmd.small_icon = File.join(@ifolder, "add9_l.png")
      cmd.large_icon = File.join(@ifolder, "add9_l.png")
      cmd.tooltip = s.capitalize
      cmd.status_bar_text = "La ligne passée par la gomme après l'activation sera masquée mais non éffacée "
      menu.add_item cmd
      toolbar.add_item cmd
	  
	  #*********************Sliding hidden********************
	  s = "Elevation"
      cmd = UI::Command.new(s.capitalize) { self.select_unia }
      cmd.small_icon = File.join(@ifolder, "add6_l.png")
      cmd.large_icon = File.join(@ifolder, "add6_l.png")
      cmd.tooltip = s.capitalize
      cmd.status_bar_text = "Parallel facade, perspective transformation"
      menu.add_item cmd
      toolbar.add_item cmd
	  
	  #
	  # Add the unit selector
    
  
      # Don't forget to show the toolbar
      toolbar.show
      
      # Let Ruby know we have loaded this file
      file_loaded(__FILE__)
    
    end # if  


    # =====================

  
  end # af_shapestoolbar
  
end # Extensions


# =====================
