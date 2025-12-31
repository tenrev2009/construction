require 'sketchup.rb'
##
## rotation de l'élément sélectionné
##
## 
def selected_comps_and_groups
    mm = Sketchup.active_model
    ss = mm.selection
	return nil if ss.empty?
	ss.each do |cc| 
		return nil if not ((cc.instance_of? Sketchup::ComponentInstance) or (cc.instance_of? Sketchup::Group))
	end	
    ss
end

def rotate90(sel, axis)
	rv = Geom::Vector3d.new(0,0,1) if axis == "z"
	rv = Geom::Vector3d.new(0,1,0) if axis == "y"
	rv = Geom::Vector3d.new(1,0,0) if axis == "x"
	ra = 90.degrees
	#rt = Geom::Transformation.rotation(rp, rv, ra) 
	sel.each do |ent|
		rp = Geom::Point3d.new(ent.bounds.center) 		#rotation point
		ent.transform!(Geom::Transformation.rotation(rp, rv, ra))
	end	
end

if( not file_loaded?("rot90.rb") )
    UI.add_context_menu_handler do |menu|
		if menu == nil then 
			UI.messagebox("Error setting context menu handler")
		else
			if (sel = selected_comps_and_groups)
				sbm = menu.add_submenu("rotation_90")
				sbm.add_item("x axe rouge") {rotate90 sel, "x"}
				sbm.add_item("Y axe vert") {rotate90 sel, "y"}
				sbm.add_item("Z axe bleu") {rotate90 sel, "z"}
			end
		end
        
	end
end

file_loaded("rot90.rb")