require 'rubygems'
require 'thor'

class Specs < Thor 
     include Thor::Actions
     source_root File.expand_path('../templates', __FILE__)

     desc "functional NAME SITE_NAME SECTION", "creates a functional spec"
     argument :name 
     argument :site_name
     argument :section, :optional => true

     def functional(name, site_name, section=nil)
        verify_site_exists
			  if section.nil? 
			    spec_path = File.join('spec', 'isolation', "#{site_name}")
		    else 
		     spec_path = File.join("#{base_spec_path}", 'section')
			  end
			  template('functional_page_spec.tt', "#{spec_path}/#{name.underscore}_page_spec.rb")
     end

     desc "integration NAME SITES", "creates a functional spec"
      argument :name 
      argument :sites, :type => :array
      def integration
        verify_site_exists
     	  spec_path = File.join('spec', 'integration')
     	  template('integration_spec.tt', "#{spec_path}/#{name.underscore}_spec.rb")
      end

    private 

     def verify_site_exists 
        unless File.directory?(File.join(destination_root,'lib','sites', site_name.underscore))
          say "******No such site #{site_name} exists.******"
            exit 1
        end
     end

end