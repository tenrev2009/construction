#-----------------------------------------------------------------------------
#
# Copyright 2005, CptanPanic 
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
#
#-----------------------------------------------------------------------------
# Name        : GetDimensions.rb
# Type        : Tool
# Description : Displays Dimensions of Component.
# Menu Item   : Plugins -> Get Component Dimensions.
# Context-Menu: None
# Author      : CptanPanic
# Usage       : Select Component, and call script.
# Date        : December 2005
# Version     :	1.0			Initial Release.
#
#             : 2010-06 <jim.foltz@gmail.com>
#               returns "true" dimensions for rotated and scaled Group and Instance.
#
#-----------------------------------------------------------------------------

require 'sketchup.rb'

module JF
    module GetDimensions
        module_function
        def get_dimensions

            model = Sketchup.active_model
            selection = model.selection

            ### show VCB and status info...
            Sketchup::set_status_text(("GET COMPONENT DIMENSIONS..." ), SB_PROMPT)
            Sketchup::set_status_text(" ", SB_VCB_LABEL)
            Sketchup::set_status_text(" ", SB_VCB_VALUE)

            ### Get Selected Entities.
            return unless selection.length == 1
            e = selection[0]
            return unless e.respond_to?(:transformation)

            scale_x = ((Geom::Vector3d.new 1,0,0).transform! e.transformation).length
            scale_y = ((Geom::Vector3d.new 0,1,0).transform! e.transformation).length
            scale_z = ((Geom::Vector3d.new 0,0,1).transform! e.transformation).length

            bb = nil
            if e.is_a? Sketchup::Group
                bb = Geom::BoundingBox.new
                e.entities.each {|en| bb.add(en.bounds) }
            elsif e.is_a? Sketchup::ComponentInstance
                bb = e.definition.bounds
            end

            if bb
                dims = [
                    width  = bb.width  * scale_x,
                    height = bb.height * scale_y,
                    depth  = bb.depth  * scale_z
                ]
				UI.messagebox("width:\t#{dims[0].to_l}\ndepth:\t#{dims[1].to_l}\nheight:\t#{dims[2].to_l}")
            end
        end
    end
end

### do menu

if( not file_loaded?("jf_get_dimensions.rb") )
    add_separator_to_menu("Plugins")
	menu_name = "Get length / width / height"
    UI.menu("Plugins").add_item(menu_name) { JF::GetDimensions.get_dimensions }
end#if
file_loaded("jf_get_dimensions.rb")
