require 'sketchup.rb'
require 'extensions.rb'
################################################

def af_Custom(string="",file=nil)
  string=string.to_s
  unless file && FileTest.exist?(file)
    return string
  else ### it's perhaps translated
    IO.readlines(file).each{|line|
	  next if line =~ /^[#]/
      line.chomp! ### loose \n off end
      if line =~ /[<][=][=][>]/
        set = line.split("<==>")
        if set[0] == string
					string = set[1]
					break
				end
      end#if
    }
    return string
  end#if
end#def

################################################

module AF
	
	
	
	module Custom
	
	VERSION   = 'TC-Custom assistant   1.2.0'.freeze
	PREF_KEY  = 'AF_Custom'.freeze
	TITLE     = 'AF_Custom'.freeze

	path = File.dirname( __FILE__ )
	Load = File.join( path, 'af_Custom' , 'Load.rb' )
	ex = SketchupExtension.new( TITLE, Load )
	ex.version = VERSION
	ex.copyright = ' @jack '
	ex.creator = 'jack'
	ex.description = 'collection de plugin construction'
	Sketchup.register_extension( ex, true )
  
    end
end 

file_loaded( __FILE__ )