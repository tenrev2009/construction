#by thomthom

module AF::Custom
  unless file_loaded?( __FILE__ )
    #@menu = UI.menu('Tools').add_submenu('powertool')
    #@toolbar = UI::Toolbar.new('powertool by dota_')
	
	#require 'su_powertools/Save.rb'
	#require 'su_powertools/Makebox.rb'
	#require 'su_powertools/ExtrudeAlongPath.rb'
	#require 'su_powertools/Lines2tubes.rb'
	#require 'su_powertools/Zorro2.rb'
	#require 'su_powertools/Hideedge.rb'
	#require 'su_powertools/Materials.rb'
	#require 'su_powertools/PurgeAll.rb'
	#require 'su_powertools/weld.rb'
	#require 'su_powertools/dota_select_edges.rb'
	#require 'su_powertools/Smart_Pushpull.rb'
	#require 'su_powertools/A4_smartpushpull.rb'
	#require 'su_powertools/Add_page.rb'
	#require 'su_powertools/Smooth.rb'
	#require 'su_powertools/Layers.rb'
	#require 'su_powertools/HighlightColor.rb'
	#require 'su_powertools/ReadMe.rb'
	#require 'su_powertools/create_hole_on_solid.rb'
	require 'af_Custom/create_hole_on_solid.rb'
	require 'af_Custom/af_shapestoolbar.rb'
	require 'af_Custom/rot90.rb'
	require 'af_Custom/#HolePunchTool.rb'
	require 'af_Custom/jf_get_dimensions.rb'
	

    #if @toolbar.get_last_state == TB_VISIBLE
     # @toolbar.restore
    #end
  end
  
  def self.reload
    load __FILE__

	#load 'su_powertools/Save.rb'
	#load 'su_powertools/Makebox.rb'
	#load 'su_powertools/ExtrudeAlongPath.rb'
	#load 'su_powertools/Lines2tubes.rb'
	#load 'su_powertools/Zorro2.rb'
	#load 'su_powertools/Hideedge.rb'
	#load 'su_powertools/Materials.rb'
	#load 'su_powertools/PurgeAll.rb'
	#load 'su_powertools/weld.rb'
	#load 'su_powertools/dota_select_edges.rb'
	#load 'su_powertools/Smart_Pushpull.rb'
	#load 'su_powertools/A4_smartpushpull.rb'
	#load 'su_powertools/Add_page.rb'
	#load 'su_powertools/Smooth.rb'
	#load 'su_powertools/Layers.rb'
	#load 'su_powertools/HighlightColor.rb'
	#load 'su_powertools/ReadMe.rb'
	#load 'su_powertools/create_hole_on_solid.rb'
	load 'af_Custom/create_hole_on_solid.rb'
	load 'af_Custom/af_shapestoolbar.rb'
	load 'af_Custom/rot90.rb'
	load 'af_Custom/#HolePunchTool.rb'
	load 'af_Custom/jf_get_dimensions.rb'
	#load 'su_powertools/Hideedge.rb'
	
  end
  
end
file_loaded( __FILE__ )