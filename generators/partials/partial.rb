require 'rubygems'
require 'taza'
require 'thor'
require 'thor/group'

class Partial < Thor::Group 
	include Thor::Actions
	source_root File.expand_path('../templates', __FILE__)

	argument :site_name
	argument :name
	

	def create_partial
      partial_path = File.join('lib', 'sites', "#{site_name}", 'pages', 'partials')
      if File.exists?(partial_path)
      	template('partial.tt', "#{partial_path}/#{name.underscore}.rb")
  	  end
	end

end