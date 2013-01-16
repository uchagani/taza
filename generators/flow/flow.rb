require 'rubygems'
require 'taza'
require 'thor'
require 'thor/group'

class Flow < Thor::Group 
	include Thor::Actions
	source_root File.expand_path('../templates', __FILE__)

	argument :site_name
	argument :name
	

	def create_flow
      flow_path = File.join('lib', 'sites', "#{site_name}", 'flows')
      if File.exists?(flow_path)
      	template('flow.tt', "#{flow_path}/#{name.underscore}.rb")
  	  end
	end

end