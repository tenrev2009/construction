#BST Create Hole on solid
# Copyright TAK2
# release v1.0   on  2011 / 11 / 28
# v1.01 modified on  2011 / 11 / 29
# v1.2 modified on 2011 / 12 / 1:This will work on sketchup ver7.and curve in the face for hole.
# v1.3 modified on 2011 / 12 / 3:Small Improve and bugfix.
# v1.4 small Improve(?).Hole as wild on not solid not occluded group.very much faults.
# v1.5b Not create new component for hole.and Able to create hole from Component with cut openning option.
# v1.5c Improving...
# v1.6 in Dec14.2011. Hole from component and Hole on unoccluded face group.(tentative fucntion)
# v1.61 in Dec16,2011. Bugfix.It happened when you select component solid.
# v1.62 in Jan03,2012. Add new function:Punch Multiple holes.
# v1.63 in jan09,2012. Bug fix.The hole from polygon mades smoothed side faces. it's improved.

# Where download My BIM tool for sketchup
# Hole on Solid Tool
# http://forums.sketchucation.com/viewtopic.php?f=323&t=41582
# Building structure tool
# http://forums.sketchucation.com/viewtopic.php?f=323&t=35798
#
# Solid quantify
# http://forums.sketchucation.com/viewtopic.php?f=323&t=41120
#
# WHD Parametric Component
# Coming soon.

require 'sketchup.rb'

class BST_HoleOnSolid

def initialize( multi_hole = false )
	#dialogname = "BST Create Hole in Solid"
	#default = ""
	#default = Sketchup.read_default("Structure Tool", "CreateHole")
	#list_yesno=["YES","NO"].join("|")
	#if default == "" or default == nil
	#	default = list_yesyno.split("|")[0]
	#elsif not list_yesyno.split("|").index(default)
	#	default = list_yesyno.split("|")[0]
	#end
	#prompts=["Erase clicked face for hole:" ]
	#dropdowns=[list_yesno]
	#values=[ "NO" ]			
	#results = []
	#results=inputbox( prompts , values, dropdowns, dialogname )
	#@eraseface = results[0]
	@eraseface = "NO"
	#@holeoffset = 0.0
	#@holeoffset = result[1].to_l if result[1].to_l
	#return nil if not results
    #Sketchup.write_default("Structure Tool", "CreateHole", default )
	if multi_hole == true
		sel = Sketchup.active_model.selection
		if sel.count == 0
			UI.messagebox "！Operation error! Please select a component with the 'cut opening' attribute."
			Sketchup.active_model.select_tool nil
			return
		end
		@sel = sel.map{|e| e }
	end
	@multi_hole = multi_hole
    reset
end

def reset
    @state = 0
	Sketchup.active_model.selection.clear
	Sketchup::set_status_text "Select object"
end

def activate
	self.reset
end
def get_entitiesbounds( ents )
	ents2 = ents.find_all{|e| e.kind_of? Sketchup::Drawingelement }
	ptmax = [0,0,0]
	ptmin = [0,0,0]
	chk = false
	ents2.each{|e|
		if chk == false
			ptmax = e.bounds.max
			ptmin = e.bounds.min
			chk = true
		else
			ptmax.x = e.bounds.max.x if ptmax.x < e.bounds.max.x
			ptmax.y = e.bounds.max.y if ptmax.y < e.bounds.max.y
			ptmax.z = e.bounds.max.z if ptmax.z < e.bounds.max.z
			
			ptmin.x = e.bounds.min.x if ptmin.x > e.bounds.min.x
			ptmin.y = e.bounds.min.y if ptmin.y > e.bounds.min.y
			ptmin.z = e.bounds.min.z if ptmin.z > e.bounds.min.z
		end
	}
	return ptmax , ptmin
end

def subtract_start(view)
	if @ce2.kind_of? Sketchup::ComponentInstance
		tr = @ce2.transformation
		arr_id = []
		crvs = []
		edges = []
		@ce2.definition.entities.each{|e|
			if e.kind_of? Sketchup::Edge
				if e.start.position.z == 0 and e.end.position.z == 0
					crv =  e.curve
					if crv == nil
						if arr_id.index( e.entityID ) == nil
							arr_id.push e.entityID
							edges.push [ e.start.position.transform( tr ) , e.end.position.transform( tr ) ]
						end
					elsif crv.is_polygon? == false
						p "curve"
						crv.edges.each{|ed|
							arr_id.push ed.entityID
						}
						crvs.push crv.vertices.map{|vt| vt.position.transform( tr ) }
					elsif crv.is_polygon? == true
						p "polygon"
						crv.edges.each{|ed|
							arr_id.push ed.entityID
							edges.push [ ed.start.position.transform( tr ) , ed.end.position.transform( tr ) ]
						}
					end
				end
			end
		}
		frames = [ edges , crvs ]
		subtract_form_MS( @ce , frames )
	else
		arr_id = []
		crvs = []
		edges = []
		@ce2.edges.each{|ed|
			crv =  ed.curve
			if crv == nil
				if arr_id.index( ed.entityID ) == nil
					arr_id.push ed.entityID
					edges.push [ ed.start.position , ed.end.position ]
				end
			elsif crv.is_polygon? == false
				crv.edges.each{|ed2|
					arr_id.push ed2.entityID
				}
				crvs.push crv.vertices.map{|vt| vt.position }
			elsif crv.is_polygon? == true
				p "polygon"
				crv.edges.each{|ed2|
					arr_id.push ed2.entityID
					edges.push [ ed2.start.position , ed2.end.position ]
				}			
			end
		}
		mat = @ce2.material
		frames = [ edges , crvs ]
		subtract_form_MS( @ce , frames ,mat )
	end
	view.invalidate
end
def subtract_form_MS( cform , frames , mat = nil )
	if cform.kind_of? Sketchup::Group
		subtract_form( cform , cform , cform.entities , frames , mat )
	elsif cform.kind_of? Sketchup::ComponentInstance
		subtract_form( cform , cform.definition , cform.definition.entities , frames , mat )
	end
	#if @eraseface == "YES"
	#	klist = cface.edges
	#	klist.push cface
	#	cface.parent.entities.erase_entities klist
	#end
end
def isOcclude( grp )
	ents = grp.entities if grp.kind_of? Sketchup::Group
	ents = grp.definition.entities if grp.kind_of? Sketchup::ComponentInstance
	return false if ents.find_all{|e| e.kind_of? Sketchup::Edge }.find_all{|e| e.faces.size != 2 and e.faces.size != 4 and e.faces.size != 6}.size > 0
	return true
end
def subtract_form( cform , cdef , cents , frames , mat ) #cface1 )
	p "ok"
	isocc = isOcclude( cform )
	Sketchup.active_model.start_operation "Solid cut openning"
	cftr = cform.transformation
	#
	#cfvts = cface1.outer_loop.vertices.map{|vt| vt.position.transform( cftr.inverse ) } ##.position.transform( cftr ) 
	#cents
	cfgrp1 = cents.add_group
	edges = frames[0]
	crvs = frames[1]
	crvs.each{|crv|
		cfgrp1.entities.add_curve crv.map{|pt| pt.transform( cftr.inverse ) }
	}
	edges.each{|pts|
		cfgrp1.entities.add_edges pts.map{|pt| pt.transform( cftr.inverse ) }
	}
	#cfgrp1
	cfgrp1.entities.find_all{|e| e.kind_of? Sketchup::Edge }.each{|ed| ed.find_faces }
	#cfgrp1
	cfgrp1.entities.erase_entities( cfgrp1.entities.find_all{|e| e.kind_of? Sketchup::Edge }.find_all{|ed| ed.faces.size != 1 } )
	cfgrp1.entities.find_all{|e| e.kind_of? Sketchup::Face }.each{|fc|
		fc.material = mat if mat != nil
	}
	p mat
	p mat.name if mat != nil
	cfgrp2 = cfgrp1.copy
	cfgrp2.make_unique
	cfgrp2.visible = false
	#cfgrp0 = Sketchup.active_model.active_entities.add_group cface1 #
	#cfinst0 = cfgrp0.to_component #
	#cfdef = cfinst0.definition
	#cfitr0 = cfinst0.transformation
	#cfinst1 = cents.add_instance( cfdef , cftr.inverse * cfitr0 ) #

	#cfinst2 = cents.add_instance( cfdef , cftr.inverse * cfitr0 ) #
	#cfinst2.transformation = cfinst1.transformation 
	#cfinst2.make_unique
	#cfinst2.visible = false
	#cfinst0.explode

	#cface = cfgrp.entities.find_all{|e| e.kind_of? Sketchup::Face }[0]
	cface = cfgrp1.entities.find_all{|e| e.kind_of? Sketchup::Face }[0]
	model = Sketchup.active_model
	ents = model.active_entities
	#
	vt_in_fc = []
	vtlist_ori = []
	vthash_ori = Hash.new

	#cfgtr = cfinst1.transformation
	cfgtr = cfgrp1.transformation
	nvec1 = cface.normal.transform( cfgtr ).normalize
	nvec1ori = cface.normal.normalize
	nvec2 = nvec1.reverse
	nplane = [ cface.vertices[0].position.transform( cfgtr ) , nvec1 ]
	dist1 = 0.0
	dist2 = 0.0
	vtlist_ori = []

	cents.each{|e|
		if e.kind_of? Sketchup::Face
			e.vertices.each{|vt|
				vthash_ori[ vt.entityID ] = vt if vthash_ori.key?( vt.entityID ) != true
			}
		end
	}

	vthash_ori.each{|eid , e|
		pt1 = e.position
		pt2 = pt1.project_to_plane( nplane )
		pt2fc = pt2.transform( cfgtr )#
		dist3 = pt1.distance_to_plane( nplane )
		ppvec = pt2.vector_to( pt1).normalize
		if cface.classify_point( pt2fc ) < 16
			#
			vt_in_fc.push e
		end
		#p "#{ppvec}::::#{nvec1}"
		if  ppvec == nvec1
			#p "a:#{dist3}"
			dist1 = dist3 if dist1 < dist3
		elsif ppvec == nvec2
			#p "b:#{dist3}"
			dist2 = dist3 if dist2 < dist3
		else
			#p "c:#{dist3}"
			dist1 = dist3 if dist1 < dist3
			dist2 = dist3 if dist2 < dist3
		end		
	}
	
	dist1 = dist1 + 100.mm
	dist2 = dist2 + 100.mm

	cface.pushpull dist1
	cface.pushpull dist2

	kill_fcs = []
	lp_fc1 = []
	#cfgrp
	#cfinst1.definition.entities.each{|fc|
	cfgrp1.entities.each{|fc|
		if fc.kind_of? Sketchup::Face
			#
			fc.reverse!
			if fc.normal.parallel?( nvec1ori )
				kill_fcs.push fc
			end
		end
	}
	#cfgrp
	if kill_fcs.size > 0
		#p "killfaces:#{kill_fcs.size}"
		lp_fc1 = kill_fcs[0].outer_loop.vertices.map{|vt| vt.position.transform cfgtr }
		#cfinst1.definition.entities.erase_entities kill_fcs
		cfgrp1.entities.erase_entities kill_fcs
	end
	#Sketchup.active_model.selection.clear
	kill_eds = []
	#cfinst1.definition.entities.each{|ed|
	cfgrp1.entities.each{|ed|
		if ed.kind_of? Sketchup::Edge
			if ed.faces.size == 0
				kill_eds.push ed
			elsif ed.faces.size == 1 
				ed.set_attribute "HOS_DEL" , "DELETE" , true
			elsif ed.faces[0].normal.normalize == ed.faces[1].normal.normalize
				#
				kill_eds.push ed
			end
		end
	}
	#cfinst1.definition.entities.erase_entities kill_eds
	cfgrp1.entities.erase_entities kill_eds

	
	vtlist_sub = []
	vthash_sub = Hash.new
	#edlist_sub = []
	#fclist_sub = []
	#cfinst1.definition.entities.each{|e|
	cfgrp1.entities.each{|e|
		if e.kind_of? Sketchup::Edge
			#edlist_sub.push e
		elsif e.kind_of? Sketchup::Face
			#fclist_sub.push e
			e.vertices.each{|vt|
				vthash_sub[ vt.entityID ] = vt if vthash_sub.key?( vt.entityID ) != true
			}
		end
	}
	vtlist_sub = vthash_sub.values
	#
	##cfgrp1.entities.intersect_with( false , cfgrp1.transformation * cftr , cform , cftr, false , cform )
	cfgrp1.entities.intersect_with( false , cfgrp1.transformation * cftr , cdef , cftr, false , cform )
	cents.intersect_with( false , Geom::Transformation.new , cfgrp1 , cfgrp1.transformation , false , cfgrp1 )
	##cfinst1.definition.entities.intersect_with( false , cfinst1.transformation * cftr , cdef , cftr, false , cform )
	##cents.intersect_with( true , Geom::Transformation.new , cfinst1.definition , cfinst1.transformation, false , cfinst1 )
	##cents.intersect_with( false , Geom::Transformation.new , cfgrp , cfgrp.transformation , false , cfgrp )

	#cfinst1.explode
	cfgrp1.explode
	#
	cents.intersect_with( false , cftr , cdef , cftr , false , cform )
	kill_eds = []
	kill_edsID = []
	cents.find_all{|e| e.get_attribute( "HOS_DEL" , "DELETE" ) == true }.each{|ed|
		kill_eds.push ed
		kill_edsID.push ed.entityID
		ed.vertices.each{|vt|
			vt.edges.each{|ed2|
				if kill_edsID.index( ed2.entityID ) == nil
					kill_eds.push ed2
					kill_edsID.push ed2.entityID
				end
			}
		}
	}
	cents.erase_entities kill_eds
	
	#

	#void_fc = cfinst2.definition.entities.find_all{|e| e.kind_of? Sketchup::Face }[0]
	void_fc = cfgrp2.entities.find_all{|e| e.kind_of? Sketchup::Face }[0]
	voidplane = void_fc.plane

	#killfcs
	kill_fcs = []
	cents.each{|e|
		if e.kind_of? Sketchup::Face
			#if e.normal.perpendicular?( void_fc.normal.transform( cfinst2.transformation ) )
			if e.normal.perpendicular?( void_fc.normal.transform( cfgrp2.transformation ) )
			else
				chk = false
				msh = e.mesh 0
				mpts = msh.polygon_points_at 1
				opt = [0,0,0]
				mpts.each{|mpt|
					(0..2).each{|i| opt[i] = opt[i] + mpt[i] }
				}
				(0..2).each{|i| opt[i] = opt[i] / mpts.size.to_f }
				#opt.transform!( cfinst2.transformation.inverse )
				opt.transform!( cfgrp2.transformation.inverse )
				pt2 = opt.project_to_plane( voidplane )
				if void_fc.classify_point( pt2 ) > 7
					#
					#chk = true
				else
					kill_fcs.push e
				end
			end
		end
	}
	cents.erase_entities kill_fcs
	#cents.erase_entities cfinst2
	cents.erase_entities cfgrp2
	if isocc == false
		10.times{
		kills = []
			cents.each{|e|
				if e.kind_of? Sketchup::Edge
					kills.push e if e.faces.size == 0
				end
			}
			if kills.size > 0
				cents.erase_entities kills
			else
				break
			end
		}	
	elsif isocc == true ##isocc means cform is occluded.so Delete as sensive.	
	#
	10.times{
	kills = []
		cents.each{|e|
			if e.kind_of? Sketchup::Edge
				kills.push e if e.faces.size < 2
			end
		}
		if kills.size > 0
			cents.erase_entities kills
		else
			break
		end
	}
	Sketchup.active_model.selection.clear
	kills = []
		cents.each{|e|
			if e.kind_of? Sketchup::Face
				edcount = 0
				e.edges.each{|ed|
					edcount += 1 if ed.faces.size == 2 or ed.faces.size == 4 or ed.faces.size == 8
				}
				#
				#
				if edcount < 3
					kills.push e
				end
			end
		}
		cents.erase_entities kills	if kills.size > 0
	
	#
	kills = []
		cents.each{|e|
			if e.kind_of? Sketchup::Edge
				kills.push e if e.faces.size < 2
			end
		}
		cents.erase_entities kills	if kills.size > 0
end#isocc

	Sketchup.active_model.commit_operation
	#if cform.deleted? or cform.volume <= 0.0
	if isocc == true
	if cform.deleted? or isOcclude( cform ) == false
		Sketchup.undo
		UI.messagebox "I am sorry! The operation was aborted.."
	end
	end
end

def increment_state(view)
    @state += 1
    case @state
    when 1
		if @multi_hole == true
			@sel.each{|e|
				if e.kind_of? Sketchup::Face
					@ce2 = e
					self.subtract_start(view)
				elsif e.kind_of? Sketchup::ComponentInstance
					pb = e.definition.behavior
					if pb.cuts_opening?
						@ce2 = e
						self.subtract_start(view)
					end
				end
			}
			self.reset
		else
			Sketchup.active_model.selection.add @ce
			Sketchup::set_status_text "Select face for hole"
		end
    when 2
        self.subtract_start(view)
        self.reset
    end
end

def onMouseMove(flags, x, y, view)

end

def onLButtonDown(flags, x, y, view)
	ph = view.pick_helper
	ph.do_pick x,y
	pe = ph.best_picked

	model = Sketchup.active_model
	cmodel = model.active_entities.parent
  case @state
  when 0
	if pe.kind_of? Sketchup::ComponentInstance or pe.kind_of? Sketchup::Group
		#if pe.volume > 0.0
		#if isOcclude( pe )
			@ce = pe.make_unique
			self.increment_state(view)
		#end
	end
  when 1
	if pe.kind_of? Sketchup::Face
		@ce2 = pe
		Sketchup.active_model.selection.add @ce2
		self.increment_state(view)
	elsif pe.kind_of? Sketchup::ComponentInstance
		pb = pe.definition.behavior
		if pb.cuts_opening?
			@ce2 = pe
			Sketchup.active_model.selection.add @ce2
			self.increment_state(view)			
		end
	end
  end
end
end # of class


#unless( file_loaded?( File.basename(__FILE__) ) )
#	UI.menu.add_item("Hole On Solid" ) { Sketchup.active_model.select_tool BST_HoleOnSolid.new }
#	hos_tb = UI::Toolbar.new("Hole On Solid")
#	cmd_hos = UI::Command.new( "Hole On Solid" ) { Sketchup.active_model.select_tool BST_HoleOnSolid.new( false ) }
#	cmd_hos.large_icon = cmd_hos.small_icon = pdir+"/icon_openning_lg.png"
#	hos_tb.add_item( cmd_hos )
#	cmd_hos = UI::Command.new( "Multi Hole" ) { Sketchup.active_model.select_tool BST_HoleOnSolid.new( true ) }
#	cmd_hos.large_icon = cmd_hos.small_icon = pdir+"/icon_multi_openning_lg.png"
#	cmd_hos.status_bar_text = cmd_hos.tooltip = "Multi Hole"
#	hos_tb.show if hos_tb.get_last_state != 0
#end
#file_loaded(File.basename(__FILE__))
