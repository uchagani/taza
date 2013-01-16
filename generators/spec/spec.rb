require 'rubygems'
require 'thor'

class Specs < Thor 
     include Thor::Actions
     source_root File.expand_path('../templates', __FILE__)

     desc "functional NAME SITE_NAME SECTION", "creates a functional spec"

     def functional(name, site_name, section=nil)
     	@name = name 
     	@site_name = site_name
     	puts "isolation test #{name} for #{site_name} "
		base_spec_path = File.join('spec', 'isolation', "#{site_name}")
		if File.exists?(base_spec_path)
			if section.nil? 
				spec_path = base_spec_path
		    else 
		    	spec_path = File.join("#{base_spec_path}", 'isolation')
			end
			template('functional_page_spec.tt', "#{spec_path}/#{name.underscore}_page_spec.rb")
		end
     end

     desc "integration NAME SITES", "creates a functional spec"
     argument :name 
     argument :sites, :type => :array
     def integration
     	spec_path = File.join('spec', 'integration')
     	template('integration_spec.tt', "#{spec_path}/#{name.underscore}_spec.rb")
     end
end