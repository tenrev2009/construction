=begin
(c) TIG 2010/2011/2012/2013
Permission to use, copy, modify, and distribute this software for 
any purpose and without fee is hereby granted, provided the above
copyright notice appear in all copies.

THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
________________________________________________________________________________

Script:

  #HolePunchTool.rb
  
place it in the ../Plugins/ folder...

From v1.6 it also requires 'af_Custom.rb' in the ../Plugins/ folder and 
any required locale lingvo files in the ../Plugins/TIGtools sub-folder...
e.g. #HolePunchToolEN-US.lingvo, #HolePunchToolFR.lingvo etc...
________________________________________________________________________________

Overview:

This script adds a new tool for glued/cutting component-instances.
It allows them to punch linked 3D holes through the faces of double-skinned walls/roofs etc.  
It is accessed through the right-click context-menu 'Hole Punching...' sub-menu, which offers various items depending on the current Selection.
________________________________________________________________________________

Usage:

1. TO PUNCH A HOLE:

Select a component-instance** that has already been placed on the face of a wall or roof etc - e.g. a newly inserted/imported or created window component.
The right-click context-menu 'Hole Punching...' sub-menu should then include 'Punch' as an option - pick it.
Only selected component-instances of a definition with a gluing/cutting capability will be processed.
In addition to the externally 'cut' 2D hole, the instance will now punch a hole through to any inner-face of that 'wall' - using the inner-face's material/layer etc for the reveals, or if there is no inner-face it will make a maximum depth reveal using the outer-faces' material/layer etc for the reveals 
[Note that there is a 'Set Depth' option - see below].
The component-instance and the punched-hole's reveals' geometry are given 'HolePunching' attributes that link them together so they will then 'transform' as one.
**Several component-instances can be selected and processed in one go - however, if any of the selected component-instances are already 'punched' [and therefore have 'HolePunching' attributes] then the 'Punch' option will not be available - only 'Undo Punch' will be shown - see below...
NOYTE: from v2.3 the punched hole will be made through multi-leaf walls [up to the maximum set Depth]
The material/layer of the innermost face will be used for all of the reveal's faces.


2. TO UNDO A PUNCHED HOLE:

Select a component-instance** that has been placed on a face that is 'punched' [i.e. it has 'HolePunching' attributes].
The right-click context-menu 'Hole Punching...' sub-menu should then include 'Undo Punch' as an option - pick it.
The selected component-instance will no longer punch a 3D hole through the whole 'wall' - it will only make the 2D 'cut' hole in its front 'parent' face as any normal 'cutting' component.
The punched-hole's reveals' geometry will be completely removed and the inner face healed.
That component-instance will also have its 'HolePunching' attributes removed.
**Several 'punching' component-instances can be selected and 'undone' in one go.


3. TO UNLINK A COMPONENT-INSTANCE AND ITS PUNCHED HOLE:

If you Select a 'Hole Punching' component-instance then its punched-hole's reveals will auto-select too, so that they will always 'transform' together - e.g. they will Move as one item.
If you Select any geometry forming a punched-hole all of its geometry will auto-select, but the linked component-instance will not be auto-selected.
You can 'unlink' a component-instance and its punched-hole.
Select a component-instance** that has been placed on a face that is 'punched' [i.e. it has 'HolePunching' attributes].
The right-click context-menu 'Hole Punching...' sub-menu should then include 'Unlink Punch' as an option - pick it.
The component-instance and its punched-hole's geometry are now 'unlinked' and their 'HolePunching' attributes are removed.
This 'unlinking' is permanent - so use it with care.
If later on you should want to 'Punch' the component-instance again you can, BUT the earlier punched-hole's geometry should perhaps be deleted or relocated, OR the component-instance relocated on the face to suit, to avoid clashes.
So for example the now 'unlinked' component-instance can be Moved, but the now 'unlinked' punched-hole will stay as where is; or you can Select+Erase the component-instance and the punched-hole will remain unselected and therefore unchanged.
Also the punched-hole geometry is no longer linked together and individual parts of it can now be edited as with any other 'hole' formed manually in faces.
**Several 'punching' component-instances can be selected and 'unlinked' in one go.


4. TO ERASE A PUNCHED HOLE:

If you Select the punching component-instance its punched-hole's reveals will also be auto-selected.
If you were then to press 'delete' the punching component-instance and all of its punched-hole's reveals will be removed.
Alternatively, if you Select any part of a punched-hole's reveals then all of the reveals' geometry is selected.
If you were then to press 'delete' all of that reveals' geometry will be removed; however, the punching component-instance is kept - in this case the punching component-instance automatically looses its 'HolePunching' attributes as it has no 'hole' remaining.  
Therefore the right-click context-menu 'Hole Punching...' sub-menu should then include 'Punch' as its option.
If you use the Erase tool to remove a punching component-instance then the punched-hole and its reveals is NOT removed.
If you use the Erase tool [perhaps by accident] to remove only some of the punched-hole's reveals' geometry then the punching component-instance will still have its 'HolePunching' attributes linked to the punched-hole's remaining geometry, and in that case the right-click context-menu 'Hole Punching...' sub-menu will still include 'Undo Punch' as an option.
You can pick that to 'tidy up' and remove the punched-hole's remaining geometry.
You can always 'Punch' the component-instance afterwards to 'redo' the punched-hole properly, as by then the component-instance will not have 'HolePunching' attributes.
Note that you can also 'Unlink' the component-instance and its punched-hole - see above...


5. TO SWAP A PUNCHING COMPONENT-INSTANCE'S COMPONENT-DEFINITION FOR A DIFFERENT COMPONENT-DEFINITION:

You can swap a hole-punching component-instance's component-definition for a different component-definition using the tools built into the Component-Browser ["Replace Selected" etc].  
This replacement component-definition might not cut a hole that is the same shape or size as the component-definition of the original component-instance.
Because the component-instance keeps its links to the reveals' geometry you can correctly this quite easily - use the 'Redo Punch' tool [or alternatively use 'Undo Punch' to remove the incorrectly formed holes/reveals, then immediately use 'Punch'], to re-punch the correct sized holes/reveals to suit the replacement component-definition's form.


6. TO SET THE MAXIMUM PUNCH DEPTH:

By default the 'Punch' will only operate on any inner-face found behind the wall's outer-face, and that in parallel it, AND that faces in the opposite direction, AND that is within 20" [500mm] of it - which is a reasonable maximum wall thickness to expect in most buildings.  
However, you can adjust this maximum reveal depth at anytime - and its value is remembered with the SKP model.
To change this use the right-click context-menu 'Hole Punching...' sub-menu 'Set Depth'.
This item might be shown on its own if there are no suitable component-instances selected OR be displayed after 'Punch' or 'Undo Punch/Unlink Punch' depending on what is selected.
A simple dialog opens showing the current depth.
Enter a new maximum depth for the punched-hole's reveals, in the model's current units.
Click OK to save the currently entered value, or Cancel to leave it as it was originally shown.
The depth must be more that zero [0] and it should be carefully considered... because making it too large could result in the inner hole/reveals being formed with a face across the room !!!
However, if there is a suitable inner-face within the current maximum depth then the punched-hole will be made to suit the actual distance between the two faces.
Otherwise if there is no suitable inner-face within the maximum depth [e.g. it's a single skin wall, or the wall is very thick] then the punched-hole will be made using the maximum depth.


7. TRANSFORMATIONS:

The punched-holes/reveals geometry is linked to the punching component-instance with 'HolePunching' attributes and an 'observer'; therefore they will always 'Select' together.
Therefore the punched-hole/reveals geometry will Move, Rotate, Scale etc with the punching component-instance as if they were one item. 
The punched-holes' perimeter Edges are also linked to the two faces by virtue of them being coplanar: so if either of the wall's two faces are moved relative to each other and thereby the wall's 'thickness' changes then the punched-hole's reveals will be automatically adjusted to suit, always filling the distance between the two faces.


8. COPYING:

With the newer version of this Tool you can now 'Copy' a punching component-instance [and its auto-selected punched-hole's geometry] using Move+Ctrl or Rotate+Ctrl [with xN or /N to 'Array' them if desired].  
Each instance 'copy' will ultimately be 'made-unique' with its own linked punched-hole's geometry.
Note that while you continue using the Move Tool or Rotate Tool these copies will remain 'unbaked', so you must change Tool to another Tool - say the Select Tool - to complete these punched copies to re-glue/un-punch/re-punch them appropriately... 
To undo this copying you will need to do two 'Undoes' - the first to undo the 'fix-duplicates' and the second to undo the Copy/Array itself that was done using the external tool.  Do not leave the 'half-baked' copies after one undo, as the hole-punching will be 'cross-threaded' between instances and the new copies will not be glued to the face etc.
Note that this method of copying does mean that any 'tweaking' that might have been done to the original's reveals - e.g. splaying the sides - will be lost because ALL instances including the original one will need to be re-glued/un-punched/re-punched to resolve any copying conflicts and make them all unique.
If you are making many copies by 'Array' then it will be quicker to do this using a non-punched original component, then afterwards select it and all arrayed copies, and punch them en mass; rather that selecting a punched instance, arraying it etc, since all of them will then need re-gluing/un-punching/re-punching - which is over three times as many operations - so there will be a noticeable lag before the lot get made-unique...  Remember that you can always quickly un-punch the original before copying and re-punch it with the rest after arraying...
If you do have customized reveals that you wish to retain then you need to place new instances, punch them and then 'tweak' each of their reveals as desired.
Also note that any punching-components within groups etc that are themselves copied and exploded together are also caught and will be 'made-unique'.
Note that using Edit>Copy>Paste with 'punching-components' might sometimes give unreliable results [depending on their geometry/origin], so be warned! It's recommended that you use Move+Ctrl for copying 'punching-components'...


9. REDO PUNCH:

The new version includes a 'Redo Punch' context-menu option.  
It is useful if you have edited a component's shape so that the linked punched-hole's geometry is no longer the same shape as the punching-instance itself, or you have swapped an instance's definition for one with a different form.
This tool allows you to Select affected punching-instances and 'redo' their hole punching to match their current form.  It is an alternative to using 'Undo Punch' and then 'Punch' on such instances.


10. REGLUE:

The new version includes a 'Reglue' context-menu option.
If you have erased a face that contained standard 'hole-cutting' instances you might have noticed that they are NOT automatically reglued to any new face you might try to reform to replace the original erased one.
This 'ungluing' will also occur with a 'hole-punching' instance made with these tools so that a full hole will no longer be punched through both wall faces.
This 'Reglue' tool can be used to reglue any such wayward instances.
Note that it works for both instances of standard 'hole-cutting' components AND this tool's own 'hole-punching' instances.  
You simply Select the affected instances [you don't need to be too careful selecting as 'non-gluing' objects are ignored anyway] and then run the 'Reglue' tool from the context-menu - they will each glue to the face that they are currently placed on and 'cut' the appropriate hole in that face: with any hole-punching ones the full depth punched hole will also reappear as before...


11. UNDO:

All Hole-Punching operations are 'one step' undoable.
However, note that when copying punching component-instances the first 'undo' will undo the tool's 'fix-duplicates' operation but a second 'undo' is needed to undo the actual copying itself.


12. ACROSS-SESSION ATTRIBUTES:

The Hole Punching 'maximum depth' is remembered across sessions, saved within each model.
The connectivity between each punching component-instance and its punched-hole's geometry is remembered across sessions, using their linking 'HolePunching' attributes and 'observers'.
Provided that this script loads at startup, setting the 'observers', then they will continue to auto-select as one and therefore transform as one etc.

________________________________________________________________________________

Donations:
by PayPal to info @ revitrev.org
________________________________________________________________________________
=end
########################
require('sketchup.rb')
load('af_Custom.rb')
########################

##########################################################
module TIG ###############################################
##########################################################

### add context menu items
unless file_loaded?(__FILE__)
  UI.add_context_menu_handler{|menu|
    cmd1=UI::Command.new(TIG::HolePunchTool.db("Punch")){TIG::HolePunchTool.new()}
    cmd2=UI::Command.new(TIG::HolePunchTool.db("Undo Punch")){TIG::HolePunchTool.undo_punch()}
    cmd3=UI::Command.new(TIG::HolePunchTool.db("Unlink Punch")){TIG::HolePunchTool.unlink_punch()}
    cmd4=UI::Command.new(TIG::HolePunchTool.db("Redo Punch")){TIG::HolePunchTool.redo_punch()}
    cmd5=UI::Command.new(TIG::HolePunchTool.db("Reglue")){TIG::HolePunchTool.reglue()}
    cmd6=UI::Command.new(TIG::HolePunchTool.db("Set Depth")){TIG::HolePunchTool.set_depth()}
    cmd1.set_validation_proc{TIG::HolePunchTool.status()==1 ? MF_ENABLED : MF_GRAYED}
    cmd2.set_validation_proc{TIG::HolePunchTool.status()==2 ? MF_ENABLED : MF_GRAYED}
    cmd3.set_validation_proc{TIG::HolePunchTool.status()==2 ? MF_ENABLED : MF_GRAYED}
    cmd4.set_validation_proc{TIG::HolePunchTool.status()==2 ? MF_ENABLED : MF_GRAYED}
    cmd5.set_validation_proc{TIG::HolePunchTool.status()>=1 ? MF_ENABLED : MF_GRAYED}
    #cmd6.set_validation_proc{TIG::HolePunchTool.status()>=0 ? MF_ENABLED : MF_GRAYED}
    hpmenu=menu.add_submenu(TIG::HolePunchTool.db("Hole Punching")+"...")
    hpmenu.add_item(cmd1)
    hpmenu.add_item(cmd2)
    hpmenu.add_item(cmd3)
    hpmenu.add_item(cmd4)
    hpmenu.add_item(cmd5)
    hpmenu.add_item(cmd6)
  }#end menu
end
file_loaded(__FILE__)
##########################################################

#####
class TIG::HolePunchTool #######################################################
#####
  def initialize(inst=nil)
    @inst=inst
    @model=Sketchup.active_model
	@selection=@model.selection
    @ments=@model.active_entities
	punching_components=[]
  if not @inst #################################
	#if @selection.empty? 
	  #UI.messagebox(self.db("No Selection. Select Punching Component(s).")+"\n"+self.db("Exiting."))
	  #return nil
	#end#if
    @model.start_operation(dbz("Hole Punching"))
    ############
	@selection.grep(Sketchup::ComponentInstance).each{|e|
	  if e.valid? && e.definition.behavior.is2d? && e.definition.behavior.cuts_opening?
        next unless gluee=e.glued_to
        if gluee.is_a?(Sketchup::Face)
			face=gluee
			edge_group=self.get_outline(e)
			punching_components << [e, face, edge_group, nil] if edge_group
		elsif gluee.is_a?(Sketchup::Group)
			group=gluee
			pt=e.transformation.origin
			pt.transform!(group.transformation.inverse)
			face=nil
			group.entities.grep(Sketchup::Face).each{|f|
				if f.classify_point(pt)==Sketchup::Face::PointInside
					face=f
					break
				end
			}
			if face
				edge_group=self.get_outline(e)
				punching_components << [e, face, edge_group, group] if edge_group
			end
		else
			next
		end
	  end#if
	}
	return nil unless punching_components[0]
	@selection.clear
	#unless punching_components[0]
	  #UI.messagebox(dbz("No Suitable Punching Component(s) Selected.")+"\n"+self.db("Exiting."))
	  #return nil
	#end
    ###
  elsif @inst && @inst.valid? && @inst.is_a?(Sketchup::ComponentInstance) && @inst.definition.behavior.is2d? && @inst.definition.behavior.cuts_opening?
		e=@inst
	    return nil unless gluee=e.glued_to
        if gluee.is_a?(Sketchup::Face)
			face=gluee
			edge_group=self.get_outline(e)
			punching_components << [e, face, edge_group, nil] if edge_group
		elsif gluee.is_a?(Sketchup::Group)
			group=gluee
			pt=e.transformation.origin
			pt.transform!(group.transformation.inverse)
			face=nil
			group.entities.grep(Sketchup::Face).each{|f|
				if f.classify_point(pt)==Sketchup::Face::PointInside
					face=f
					break
				end
			}
			if face
				edge_group=self.get_outline(e)
				punching_components << [e, face, edge_group, group] if edge_group
			end
		end
        return nil unless punching_components[0]
  end#if
    ### set/set attrib
    @depth=@model.get_attribute("HolePunching","depth",false)
    ### get units
    if @model.options["UnitsOptions"]["LengthUnit"]<=1 ### it's '/"
      @depth=20.inch unless @depth
    else ### it's metric
      @depth=500.mm unless @depth
    end#if
    ###
    @model.set_attribute("HolePunching","depth", @depth)
    ###
	 punching_components.each{|pc|self.punch_component(pc)}
	###
    @model.commit_operation unless @inst
    #################
    return nil
    #################
  end#end 'new'
  
  	def self.db(string)
	  dir=File.join(File.dirname(__FILE__), "TIGtools")
	  toolname="#HolePunchTool"
	  locale=Sketchup.get_locale.upcase
	  path=File.join(dir, toolname+locale+".lingvo")
	  unless File.exist?(path)
		return string
	  else
		af_Custom(string, path)
	  end 
	end#def
	
	def dbz(string)
		TIG::HolePunchTool.db(string)
	end

  def get_outline(punching_component)
    dfn=punching_component.definition
    tra=Geom::Transformation.new(ORIGIN)
    grp=@ments.add_group()
    gents=grp.entities
    ins=gents.add_instance(dfn, tra)
    bb=ins.bounds
    min=bb.min
    max=bb.max
    minn=[min.x-1, min.y-1, 0]
    minx=[max.x+1, min.y-1, 0]
    maxx=[max.x+1, max.y+1, 0]
    miny=[min.x-1, max.y+1, 0]
    face=gents.add_face(minn, minx, maxx, miny)
    face.reverse! if face.normal.z<0
    ins.explode   
    xploded=false ### now explode any other contents we can
    until xploded==true
      #gents.to_a.each{|e|e.explode if e.respond_to?(:explode)} ###v2.1
      gents.to_a.each{|e|e.explode if e.is_a?(Sketchup::Group) || e.is_a?(Sketchup::ComponentInstance)}
      gents.to_a.each{|e|
        next unless e.valid?
        if e.is_a?(Sketchup::Group) || e.is_a?(Sketchup::ComponentInstance)
          xploded=false
          break
        end#if
        xploded=true
      }
    end#until
    gents.to_a.each{|e|
      next unless e.valid?
      if e.is_a?(Sketchup::Face)
        e.erase!
      elsif e.is_a?(Sketchup::Edge)
        e.erase! if e.end.position.z != 0 || e.start.position.z != 0
      end#if
    }
    gents.grep(Sketchup::Edge).each{|e|e.find_faces}
    togo=[]
    gents.grep(Sketchup::Edge).each{|e|
      next unless e.valid?
      togo << e unless e.faces[1]
    }
    gents.erase_entities(togo)
    togo=[]
    gents.grep(Sketchup::Edge).each{|e|
      next unless e.valid?
      togo << e if e.faces[1]
    }
    gents.erase_entities(togo)
    gents.grep(Sketchup::Edge).each{|e|e.find_faces}
    return grp if grp.valid?
    return nil
  end#end get_outline

  def punch_component(carray)
    compi=carray[0]
    iface=carray[1]
    croup=carray[2]
	contr=carray[3]
    return nil unless compi && compi.valid?
    return nil unless iface && iface.valid?
    return nil unless croup && croup.valid?
    #return nil unless compi.parent == iface.parent
    pents=iface.parent.entities
    ifacenormal=iface.normal
    ifacematerial=iface.material
    ifaceback_material=iface.back_material
    ifacelayer=iface.layer
    ifaceplane=iface.plane
    ### add and transform group
    tr=compi.transformation
	if contr ### inside a group
		tr = contr.transformation.inverse * tr
	end
    group=pents.add_instance(croup.entities.parent, tr)
		croup.erase!
    ### process group's faces
    #nfaces = group.entities.grep(Sketchup::Face)
    ex=group.explode
		nfaces=ex.grep(Sketchup::Face)
    ### set unique idd for this instance
    idd=Time.now.to_i.to_s+rand.to_s
    ### add idd to component-instance [compi]
    @selection.add(compi) unless @inst
		if compi && compi.valid?
			self.add_attribute(compi,"inst",true) 
			self.add_attribute(compi,"id",idd)
			if contr ### in a group
				unless idg=contr.get_attribute("HolePunching","idg",false)
					idg=Time.now.to_i.to_s+rand.to_s
					self.add_attribute(contr,"idg",idg) 
				end
				self.add_attribute(compi,"idg",idg)
			end
		end
		#p compi.get_attribute("HolePunching","id",-666)
    ###
    nfaces.each{|new_face|
	  if new_face && new_face.valid?
        cent=new_face.bounds.center
        cent=cent.project_to_plane(ifaceplane)
        new_face.reverse! if new_face.normal != ifacenormal
        new_face_edges = new_face.edges
		reveal_geom = []+new_face_edges
        vec = ifacenormal.reverse
        inner_face=nil
        ### get all faces with vec normal OR parallel
        faces=[]
        pents.grep(Sketchup::Face).each{|e| faces << e if e.normal.parallel?(vec) }
        ### remove face 'level' OR if too far away OR on wrong side of outer-face 
		### AND point is NOT on the face...
        cfaces = []+faces
        faces.each{|face|
          pt=Geom.intersect_line_plane([cent,vec],face.plane)
          if ! pt || face.plane == ifaceplane
            cfaces.delete(face)
          elsif pt 
            fcp=face.classify_point(pt)
            if fcp == Sketchup::Face::PointOutside || fcp == Sketchup::Face::PointUnknown || fcp == Sketchup::Face::PointNotOnPlane
              cfaces.delete(face)
            end#if
          end#if
          if pt && cent.distance(pt) > @depth
            cfaces.delete(face)
          end#if
        }
        faces=[]+cfaces ### all faces matching iface normal and within @depth
        ### now take 'farthest' face in remaining faces and punch up to it
        depth=0
        faces.each{|face|
          pt=Geom.intersect_line_plane([cent, vec], face.plane)
          dist=cent.distance(pt)
          if dist >= depth ### maximizes it
            inner_face = face
            depth = dist
          end#if
        }
        ###
        if ! inner_face || depth == 0
		  depth = @depth
		else
		  faces.delete(inner_face)
        end#if
		###
        entsa = pents.to_a
        ################################################
	    new_face.pushpull(-depth, false) unless depth==0
        ################################################
		#p new_face_edges
		###
		afaces=[]
		faces.each{|f|
			next unless f.valid?
			reveal=false
			f.edges.each{|ee|
				if new_face_edges.include?(ee)
					reveal=true
					break
				end
			}
			next unless reveal
			afaces << f
		}
        ###
		tr=Geom::Transformation.new()
		new_bits = pents.intersect_with(true, tr, pents, tr, true, afaces)
		fs2go=[]
		new_bits.grep(Sketchup::Edge).each{|e|
			next unless e.valid?
			fs2go << e.faces
		}
		fs2go.flatten!
		fs2go.compact!
		fs2go.uniq!
		fs2go.each{|face|
			next unless face.valid?
			next unless face.normal.parallel?(vec)
			pt = Geom.intersect_line_plane([cent, vec], face.plane)
			next unless pt
            if face.classify_point(pt) == Sketchup::Face::PointInside
			  face.erase!
            end#if
		}
		###
        entsaNew = pents.to_a - entsa
        new_faces = entsaNew.grep(Sketchup::Face)
		###
		redges=[]
		new_faces.each{|f|
			next unless f.valid?
			reveal=false
			f.edges.each{|ee|
				if new_face_edges.include?(ee)
					reveal=true
					break
				end
			}
			new_faces.delete(f) unless reveal
			next unless reveal
			redges << f.edges
		}
		###
        if inner_face && inner_face.valid?
          new_faces.each{|e|
            next unless e.valid?
            e.material = inner_face.material
            e.back_material = inner_face.back_material
            e.layer = inner_face.layer
          }### match inner face
        else### match outer face as it's at max depth
          new_faces.each{|e|
            next unless e.valid?
            e.erase! if e.normal==ifacenormal && e != iface
            next unless e.valid?
            e.material = ifacematerial
            e.back_material = ifaceback_material
            e.layer = ifacelayer
          } ### remove blank 'end'
        end#if
		###
		redges.flatten!
		redges.compact!
		redges.uniq!
        ### now add attributes to geometry at end
		reveal_geom = new_faces + redges
		###
        reveal_geom.each{|e|
          next unless e.valid?
          self.add_attribute(e,"geom",true)
          self.add_attribute(e,"id",idd)
		  #next if e.is_a?(Sketchup::Edge)
          @selection.add(e) unless @inst ### OR select faces only ?
        }
		###
	  end#if new_face
    }#nfaces
    return nil
  end#end punch_component

  def add_attribute(ent,k,v)
    ent.set_attribute("HolePunching",k,v)
  end#end add_attribute

  #########################
  def self.status
    status=0
    Sketchup.active_model.selection.grep(Sketchup::ComponentInstance).each{|e|
      next unless e.definition.behavior.is2d? && e.definition.behavior.cuts_opening?
      if not e.get_attribute("HolePunching","inst",false)
        status=1 ### has suitable compoi to PUNCH
      elsif e.get_attribute("HolePunching","inst",false)
        status=2 ### has pre-punched compoi - so >>> UNDO or UNLINK etc
      end#if
    } ### we have a suitable compo...
    return status
  end#status

  def self.undo_punch(inst=nil)
    model=Sketchup.active_model
    selection=model.selection
	idd=-1
   if not inst
		#p 111
		model.start_operation(self.db("Undo Hole Punching"))
		sela=selection.to_a
		selection.clear
		sela.grep(Sketchup::ComponentInstance).each{|e|
		  next unless e.valid?
		  if idd=e.get_attribute("HolePunching","id",false)
		    next unless idd
			e.set_attribute("HolePunching","inst",nil)
			e.set_attribute("HolePunching","id",nil)
			unless e.get_attribute("HolePunching","idg",nil) ### its face is with it
				e.parent.entities.to_a.each{|ee|
					next unless ee.valid?
					if ee.is_a?(Sketchup::Face) || ee.is_a?(Sketchup::Edge)
						ee.erase! if idd==ee.get_attribute("HolePunching","id",-1)
					end
				}
			else ### it's a grouped hole
				idg=e.get_attribute("HolePunching","idg",-1)
			    e.set_attribute("HolePunching","idg",nil)
				group=nil
				e.parent.entities.to_a.each{|ee|
					#next unless ee.valid?
					if ee.is_a?(Sketchup::Group) && idg=ee.get_attribute("HolePunching","idg",nil)
						group=ee
						break
					end
				}
				if group
					#group.set_attribute("HolePunching","idg",nil) ### NO leave as others might be using it
					group.entities.to_a.each{|ee|
						next unless ee.valid?
						if ee.is_a?(Sketchup::Face) || ee.is_a?(Sketchup::Edge)
							ee.erase! if idd==ee.get_attribute("HolePunching","id",-1)
						end
					}
				end
			end
		  end#if
		}
		sela.each{|e|selection.add(e) if e.valid?}
		model.commit_operation
		#######################
   elsif inst && inst.valid? && inst.is_a?(Sketchup::ComponentInstance) && idd=inst.get_attribute("HolePunching","id",false)
		#p 222 ### 
		return nil unless idd
        e=inst
		if e.is_a?(Sketchup::ComponentInstance) && idd=e.get_attribute("HolePunching","id",false)
		    return nil unless idd
			e.set_attribute("HolePunching","inst",nil)
			e.set_attribute("HolePunching","id",nil)
			e.parent.entities.to_a.each{|ee|
				next unless ee.valid?
				if ee.is_a?(Sketchup::Face) || ee.is_a?(Sketchup::Edge)
					ee.erase! if idd==ee.get_attribute("HolePunching","id",-1)
				end
			}
			###
			if e.get_attribute("HolePunching","idg",nil) ### it's a grouped hole
				idg=e.get_attribute("HolePunching","idg",-1)
			    e.set_attribute("HolePunching","idg",nil)
				group=nil
				e.parent.entities.grep(Sketchup::Group)..each{|ee|
					#next unless ee.valid?
					if idg=ee.get_attribute("HolePunching","idg",nil)
						group=ee
						break
					end
				}
				if group
					#group.set_attribute("HolePunching","idg",nil) ### NO leave as others might be using it
					group.entities.to_a.each{|ee|
						next unless ee.valid?
						if ee.is_a?(Sketchup::Face) || ee.is_a?(Sketchup::Edge)
							ee.erase! if idd==ee.get_attribute("HolePunching","id",-1)
						end
					}
				end
			end
		end#if
   end#if
   ###
  end#undo_punch
  
  def self.unlink_punch(inst=nil)
    model=Sketchup.active_model
    selection=model.selection
	idd=-1
   if not inst
		#p 111
		model.start_operation(self.db("Unlink Hole Punching"))
		sela=selection.to_a
		selection.clear
		sela.grep(Sketchup::ComponentInstance).each{|e|
		  next unless e.valid?
		  if idd=e.get_attribute("HolePunching","id",false)
		    next unless idd
			e.set_attribute("HolePunching","inst",nil)
			e.set_attribute("HolePunching","id",nil)
			unless e.get_attribute("HolePunching","idg",nil) ### its face is with it
				e.parent.entities.to_a.each{|ee|
					#next unless ee.valid?
					if ee.is_a?(Sketchup::Face) || ee.is_a?(Sketchup::Edge)
						ee.set_attribute("HolePunching","geom",nil) if idd==ee.get_attribute("HolePunching","id",-1)
						ee.set_attribute("HolePunching","id",nil) if idd==ee.get_attribute("HolePunching","id",-1)
					end
				}
			else ### it's a grouped hole
			    idg=e.get_attribute("HolePunching","idg",-1)
				e.set_attribute("HolePunching","idg",nil)
				group=nil
				e.parent.entities.grepSketchup::Group().each{|ee|
					#next unless ee.valid?
					if idg=ee.get_attribute("HolePunching","idg",nil)
						group=ee
						break
					end
				}
				if group
					#group.set_attribute("HolePunching","idg",nil) ### NO leave as others might be using it
					group.entities.to_a.each{|ee|
						next unless ee.valid?
						if ee.is_a?(Sketchup::Face) || ee.is_a?(Sketchup::Edge)
							ee.set_attribute("HolePunching","geom",nil) if idd==ee.get_attribute("HolePunching","id",-1)
							ee.set_attribute("HolePunching","id",nil) if idd==ee.get_attribute("HolePunching","id",-1)
						end
					}
				end
			end
		  end#if
		}
		sela.each{|e|selection.add(e) if e.valid?}
		model.commit_operation
		#######################
   elsif inst && inst.valid? && inst.is_a?(Sketchup::ComponentInstance) && idd=inst.get_attribute("HolePunching","id",false)
		#p 222 ### 
		return nil unless idd
        e=inst
		if e.is_a?(Sketchup::ComponentInstance) && idd=e.get_attribute("HolePunching","id",false)
		    return nil unless idd
			e.set_attribute("HolePunching","inst",nil)
			e.set_attribute("HolePunching","id",nil)
			unless e.get_attribute("HolePunching","idg",nil) ### its face is with it
				e.parent.entities.to_a.each{|ee|
					next unless ee.valid?
					if ee.is_a?(Sketchup::Face) || ee.is_a?(Sketchup::Edge)
						ee.set_attribute("HolePunching","geom",nil) if idd==ee.get_attribute("HolePunching","id",-1)
						ee.set_attribute("HolePunching","id",nil) if idd==ee.get_attribute("HolePunching","id",-1)
					end
				}
			else ### it's a grouped hole
			    idg=e.get_attribute("HolePunching","idg",-1)
			    e.set_attribute("HolePunching","idg",nil)
				group=nil
				e.parent.entities.grep(Sketchup::Group).each{|ee|
					#next unless ee.valid?
					if idg=ee.get_attribute("HolePunching","idg",nil)
						group=ee
						break
					end
				}
				if group
					#group.set_attribute("HolePunching","idg",nil) ### NO leave as others might be using it
					group.entities.to_a.each{|ee|
						next unless ee.valid?
						if ee.is_a?(Sketchup::Face) || ee.is_a?(Sketchup::Edge)
							ee.set_attribute("HolePunching","geom",nil) if idd==ee.get_attribute("HolePunching","id",-1)
							ee.set_attribute("HolePunching","id",nil) if idd==ee.get_attribute("HolePunching","id",-1)
						end
					}
				end
			end
		end#if
   end#if
   ###
  end#unlink_punch
  
  def self.set_depth()
    model=Sketchup.active_model
    depth=model.get_attribute("HolePunching","depth",false)
    ### get units
    if model.options["UnitsOptions"]["LengthUnit"]<=1 ### it's '/"
      depth=20.inch unless depth
    else ### it's metric
      depth=500.mm unless depth
    end#if
    ###
    prompt=self.db("Max.Depth: ")
    title=self.db("Hole Punching")
    results=inputbox([prompt], [depth.to_l], title)
    return nil unless results
    if results[0] <= 0
      UI.messagebox(self.db("Depth must be > 0")+"\n"+self.db("Try Again..."))
      self.set_depth()
      return nil
    end#if
    depth=results[0]
    model.set_attribute("HolePunching","depth",depth)
  end#set_depth
  
  
  def self.fix_duplicates(defn)
    ###
    return nil unless defn && defn.is_a?(Sketchup::ComponentDefinition) && defn.valid? && ! defn.group? && ! defn.image? && defn.instances[1]
    model=Sketchup.active_model
    selection=model.selection
	ssa=selection.to_a
	ided={}
	defn.instances.each{|i|
		if idd=i.get_attribute("HolePunching","id",false)
			ided[idd]=[] unless ided[idd] 
			ided[idd]=ided[idd] << i
		end
	}
	###
	#selection.clear ### WHY? NOOOOOOOOOOOOO!!!
	###
    selection.remove_observer(@TIG_holePunchingSelection_Observer) #############
	###
	ided.to_a.each{|a|
		next unless a[1].length > 1
		a[1].each_with_index{|i, ii|
			next unless i.valid?
			idg=i.get_attribute("HolePunching","idg",false) ### gluee is group
			self.undo_punch(i)
			next if idg && ii > 0 ### only first instance gets reglued etc if group gluee
			self.reglue(i)
			self.new(i)
		}
	}
	### redo selections...
	ssa.grep(Sketchup::ComponentInstance).each{|s|
		next unless s.valid?
		selection.add(s) ### re-add to selection
		if s.get_attribute("HolePunching","inst",false) && idd=s.get_attribute("HolePunching","id",false)
			next unless idd
			s.parent.entities.to_a.each{|e| ### find matching reveals
				#next unless e.valid? 
				next unless e.is_a?(Sketchup::Face) || e.is_a?(Sketchup::Edge)
				if e.get_attribute("HolePunching","geom",false) && idd==e.get_attribute("HolePunching","id",false)
					selection.add(e)
				end#if
			}
			next unless idg=s.get_attribute("HolePunching","idg",false) ### gluee is group
			group=nil
			s.parent.entities.grep(Sketchup::Group).each{|ee|
				next unless ee.valid?
				if idg=ee.get_attribute("HolePunching","idg",-1)
					group=ee
					break
				end
			}
			if group
				group.entities.to_a.each{|ee|
					next unless ee.valid?
					if ee.is_a?(Sketchup::Face) || ee.is_a?(Sketchup::Edge)
						selection.add(ee) if idd==ee.get_attribute("HolePunching","id",-1)
					end
				}
			end
		end
	}
	###
    selection.add_observer(@TIG_holePunchingSelection_Observer) #################
	###
	begin model.active_view.refresh; rescue; end
	###
  end#fix_duplicates
  
  
  def self.reglue(instance=nil)
    model=Sketchup.active_model
    selection=model.selection
    unless instance ### we do selection
      sela=selection.to_a
      return nil unless sela
      model.start_operation(self.db("Reglue"))
      sela.grep(Sketchup::ComponentInstance).each{|instance|
        next unless instance.valid?
	    if instance.definition.behavior.is2d? && instance.definition.behavior.cuts_opening?
		  face=instance.glued_to
          next if face && face.valid? ### it's already glued to something = face OR group
          tr=instance.transformation
          co=ORIGIN.clone.transform!(tr)  ### switch to our coordinates
	      cv=Z_AXIS.clone.transform!(tr)  ### switch to our coordinates
          instance.parent.entities.grep(Sketchup::Face).each{|face|
            if face.classify_point(co)==Sketchup::Face::PointInside && face.normal.parallel?(cv)
	          instance.glued_to=face
              break
	        end#if
	      }
	    end#if
      }
      model.commit_operation
    else ### do instance
      return nil unless instance.valid?
	  face=instance.glued_to
	  return nil if face && face.valid?
      tr=instance.transformation
  	  co=ORIGIN.clone.transform!(tr)  ### switch to our coordinates
	  cv=Z_AXIS.clone.transform!(tr)  ### switch to our coordinates
      status=nil
      instance.parent.entities.grep(Sketchup::Face).each{|face|
        if face.classify_point(co)==Sketchup::Face::PointInside && face.normal.parallel?(cv)
	      status=instance.glued_to=face
          break
	    end#if
	  }
      return status
    end#if
  end#def reglue
  
  def self.redo_punch()
    model=Sketchup.active_model
    selection=model.selection
    sela=selection.to_a
    return nil unless sela
    model.start_operation(self.db("Redo Hole Punching"))
    selection.remove_observer(@TIG_holePunchingSelection_Observer)##############
    insts=[]
    sela.grep(Sketchup::ComponentInstance).each{|instance|
        next unless instance.valid?
	    if instance.get_attribute("HolePunching","inst",false) && instance.get_attribute("HolePunching","id",false)
          insts << instance
          self.undo_punch(instance)
          self.new(instance)
	    end#if
    }
	idd=-1
    insts.each{|i|
		next unless i.valid?
		selection.add(i)
		idd=i.get_attribute("HolePunching","id",false)
		next unless idd
		idg=i.get_attribute("HolePunching","idg",false)
		i.parent.entities.to_a.each{|e| ### find matching reveals
          next unless e.valid?
		  unless idg ### it's glued onto a group
			  next unless e.is_a?(Sketchup::Face) || e.is_a?(Sketchup::Edge)
			  if e.get_attribute("HolePunching","geom",false) && idd==e.get_attribute("HolePunching","id",false)
				  selection.add(e)
				  if e.is_a?(Sketchup::Face)
					e.edges.each{|ee|
						ee.set_attribute("HolePunching","geom",true)
						ee.set_attribute("HolePunching","id",idd)
						selection.add(ee)
					}
				  end
			  end#if
		  else ### sort out group
			  next unless e.is_a?(Sketchup::Group) && idg=e.get_attribute("HolePunching","idg",-1)
			  group=e
			  if group
				group.entities.to_a.each{|ee|
					next unless ee.valid?
					if ee.is_a?(Sketchup::Face) || ee.is_a?(Sketchup::Edge)
						selection.add(ee)if idd==ee.get_attribute("HolePunching","id",-1)
					end
				}
			  end
			  break ### e
		  end
        }
	}
    selection.add_observer(@TIG_holePunchingSelection_Observer)#################
    model.commit_operation
  end#def redo
  ###########################################################

end#end Class HolePunchTool ###############################################
###

##########################################################
### OBSERVERS inside new TIG module classes...
##########################################################
###
### SelectionObserver to select and move reveals with comp-inst etc
class TIG::HolePunchingSelectionObserver < Sketchup::SelectionObserver
  def onSelectionBulkChange(selection)
    ###
	model=selection.model
	###
    selection.grep(Sketchup::ComponentInstance).each{|s|
		idd = -1
		if s.get_attribute("HolePunching","inst",false) && idd=s.get_attribute("HolePunching", "id", false)
			###
			next unless idd
			idg=s.get_attribute("HolePunching", "idg", false) ### group gluee
			###
			(model.active_entities.to_a - selection.to_a).each{|e| ### find matching reveals
				#next unless e.valid? 
				unless idg ### not group gluee
					next unless e.is_a?(Sketchup::Face) || e.is_a?(Sketchup::Edge)
					if e.get_attribute("HolePunching", "geom", false) && idd==e.get_attribute("HolePunching", "id", false)
						selection.add(e)
						if e.is_a?(Sketchup::Face)
							e.edges.each{|ee|
								ee.set_attribute("HolePunching","geom",true)
								ee.set_attribute("HolePunching","id",idd)
								selection.add(ee)
							}
						end
					end#if
				else ### group gluee
					next unless e.is_a?(Sketchup::Group)
					group=nil
					group=e if idg==e.get_attribute("HolePunching","idg",false)
					next unless group
					group.entities.each{|ee|
						next unless ee.is_a?(Sketchup::Face) || ee.is_a?(Sketchup::Edge)
						if ee.get_attribute("HolePunching","geom",false) && idd==ee.get_attribute("HolePunching","id",false)
							selection.add(ee)
							if ee.is_a?(Sketchup::Face)
								ee.edges.each{|eee|
									eee.set_attribute("HolePunching","geom",true)
									eee.set_attribute("HolePunching","id",idd)
									selection.add(eee)
								}
							end
						end#if
					}
					break # e
				end
			}
			### OR do rest as it is geometry
		end
	}
	###
	selection.grep(Sketchup::Face).each{|s|
		idd = -1
		if s.get_attribute("HolePunching","geom",false) && idd=s.get_attribute("HolePunching","id",false)
			next unless idd
			(model.active_entities.to_a - selection.to_a).each{|e|
				next unless e.is_a?(Sketchup::Face) || e.is_a?(Sketchup::Edge)
				if e.get_attribute("HolePunching","geom",false) && idd==e.get_attribute("HolePunching","id",false)
					selection.add(e)
					if e.is_a?(Sketchup::Face)
						e.edges.each{|ee|
							ee.set_attribute("HolePunching","geom",true)
							ee.set_attribute("HolePunching","id",idd)
							selection.add(ee)
						}
					end
				end#if
			}
		end#if
    }
    ###
	selection.grep(Sketchup::Edge).each{|s|
		idd = -1
		if s.get_attribute("HolePunching","geom",false) && idd=s.get_attribute("HolePunching","id",false)
			next unless idd
			(model.active_entities.to_a - selection.to_a).each{|e|
				next unless e.is_a?(Sketchup::Face) || e.is_a?(Sketchup::Edge)
				if e.get_attribute("HolePunching","geom",false) && idd==e.get_attribute("HolePunching","id",false)
					selection.add(e)
					if e.is_a?(Sketchup::Face)
						e.edges.each{|ee|
							ee.set_attribute("HolePunching","geom",true)
							ee.set_attribute("HolePunching","id",idd)
							selection.add(ee)
						}
					end
				end#if
			}
		end#if
    }
    ###
  end#def
end###class SelectionObserver
###
### ToolsObserver
class TIG::HolePunchingToolsObserver < Sketchup::ToolsObserver
  def onActiveToolChanged(tools, tool_name, tool_id)
    return nil if tool_id == 0 # == NO Tool
    #puts tool_name; puts tool_id
    return nil if tool_id == 21013 # == PasteTool - otherwise it is disabled !
    model=Sketchup.active_model
	ids=[]
	idd=-1
	model.selection.each{|e|
	    ids << idd if idd=e.get_attribute("HolePunching","id",false)
	}
	ids.uniq!
	return nil unless ids[0]
	defns=[]
	model.definitions.each{|d|
		next if d.group? || d.image?
		next unless d.instances[1]
		d.instances.each{|i|
			if i.get_attribute("HolePunching","id",false) && ids.include?(i.get_attribute("HolePunching","id",false))
				defns << d
				break
			end
		}
	}
	defns.uniq!
	return nil unless defns[0]
	model.start_operation(TIG::HolePunchTool.db("Hole Punching")+" - "+TIG::HolePunchTool.db("Fix Duplicates"))
	 #ss=model.selection
	 #ssa=ss.to_a
	 defns.each{ |d| TIG::HolePunchTool.fix_duplicates(d) }
	 #ss.clear
	 #ssa.each{|e| ss.add(e) if e.valid? }
	 begin model.active_view.refresh; rescue; end
	model.commit_operation
	###
  end
end#class ToolsObserver
###
### AppObserver
class TIG::HolePunchingAppObserver < Sketchup::AppObserver
  def onNewModel(model)  ### from menu or app
    TIG.addHolePunchingObservers()
  end
  def onOpenModel(model) ### from menu
    TIG.addHolePunchingObservers()
  end
  def onQuit() ### best to tidy up
    TIG.removeHolePunchingObservers()
  end
end#class AppObserver
###

###########################################################
### back inside TIG module...
###########################################################
def self.addHolePunchingSelectionObserver()
  @TIG_holePunchingSelection_Observer=TIG::HolePunchingSelectionObserver.new unless @TIG_holePunchingSelection_Observer
  Sketchup.active_model.selection.remove_observer(@TIG_holePunchingSelection_Observer)
  Sketchup.active_model.selection.add_observer(@TIG_holePunchingSelection_Observer)
end#def
##########################################################
def self.addHolePunchingToolsObserver()
  @TIG_holePunchingTools_Observer=TIG::HolePunchingToolsObserver.new unless @TIG_holePunchingTools_Observer
  Sketchup.active_model.tools.remove_observer(@TIG_holePunchingTools_Observer)
  Sketchup.active_model.tools.add_observer(@TIG_holePunchingTools_Observer)
end#def
###########################################################
def self.addHolePunchingAppObserver()
  @TIG_holePunchingApp_Observer=TIG::HolePunchingAppObserver.new unless @TIG_holePunchingApp_Observer
  #Sketchup.remove_observer(@TIG_holePunchingApp_Observer)
  Sketchup.add_observer(@TIG_holePunchingApp_Observer)
end#def
##########################################################
### remove and add observers methods
def self.removeHolePunchingObservers()
    model=Sketchup.active_model
    model.selection.remove_observer(@TIG_holePunchingSelection_Observer)
    model.tools.remove_observer(@TIG_holePunchingTools_Observer)
    #Sketchup.remove_observer(@TIG_holePunchingApp_Observer)
end
###
def self.addHolePunchingObservers()
	self.addHolePunchingSelectionObserver()
    self.addHolePunchingToolsObserver()
    self.addHolePunchingAppObserver()
end
###########################################################
self.addHolePunchingObservers() ### at kick-off only
###########################################################
###

end#module TIG
###
