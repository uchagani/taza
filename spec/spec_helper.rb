require 'rubygems'
require 'bundler/setup'
require 'mocha'
require 'taza'
require 'watir-webdriver'
require 'selenium-webdriver'
require 'generator_spec'
require 'thor'
require 'stringio'
require 'fileutils'

# Must set before requiring generator libs.
TMP_ROOT = File.join(File.dirname(__FILE__),"sandbox","generated")
PROJECT_NAME = 'example'
PROJECT_FOLDER = File.join(TMP_ROOT,PROJECT_NAME)
APP_ROOT = File.join(TMP_ROOT, PROJECT_NAME)

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :mocha
  config.include Spec::FileMatchers
  config.include  Spec::GeneratorRunner

   
end

def null_device
  File.exist?('/dev/null') ? '/dev/null' : 'NUL'
end



Dir[File.expand_path("../..", __FILE__) + "/generators/*/*.rb"].each do |generator|
  require generator
end

module Helpers
  module Generator

    def generate_site(site_name)
     # site_name = "#{site_name}#{Time.now.to_i}"
      thor("site #{site_name}")
      site_file_path = File.join(PROJECT_FOLDER,'lib','sites',"#{site_name.underscore}.rb")
      require site_file_path
      "::#{site_name.camelize}::#{site_name.camelize}".constantize.any_instance.stubs(:base_path).returns(PROJECT_FOLDER)
      site_name.camelize.constantize
    end
  end

  module Taza
    def stub_settings
      ::Taza::Settings.stubs(:config).returns({})
    end

    def stub_browser
      stub_browser = stub()
      stub_browser.stubs(:goto)
      stub_browser.stubs(:close)
      ::Taza::Browser.stubs(:create).returns(stub_browser)
    end
  end
end

def bare_teardown
    FileUtils.rm_rf TMP_ROOT || APP_ROOT
end

def bare_setup
    FileUtils.mkdir_p(APP_ROOT)
    @stdout = StringIO.new
end



module FileExt
  # Checks if a file exists.
  def exist?
    File.exist?(path)
  end

  # The contents of the file.
  def contents
    read
  end
end

class File
  include FileExt
end