require 'rubygems'
require 'taza'
require 'thor'
require 'thor/group'

class Page < Thor::Group 
	include Thor::Actions
	source_root File.expand_path('../templates', __FILE__)

	argument :site_name
	argument :name
	argument :subtype, :optional => true
	

	def create_page
      page_path = File.join('lib', 'sites', "#{site_name}")
      if File.exists?(page_path)
      	template('page.tt', "#{page_path}/pages/#{name.underscore}_page.rb")
  	  end
	end

	def create_spec 
		base_spec_path = File.join('spec', 'isolation', "#{site_name}")
		if File.exists?(base_spec_path)
		if subtype.nil? 
			spec_path = base_spec_path
	    else 
	    	spec_path = File.join("#{base_spec_path}", 'isolation')
		end

		template('functional_page_spec.tt', "#{spec_path}/#{name.underscore}_page_spec.rb")
		end

	end
end