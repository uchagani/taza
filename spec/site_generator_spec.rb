require 'spec_helper'
require 'rubygems'
require 'fileutils'
require 'generator_spec/test_case'

describe Site, "arguments NAME" do
  include GeneratorSpec::TestCase
  include Helpers::Taza
  destination APP_ROOT

    arguments ["WikipediaFoo"]

    before :each do
      bare_setup
      prepare_destination
      run_generator
    end

    after :each do
      bare_teardown
    end

      specify do
          destination_root.should have_structure {
            directory "#{APP_ROOT}/config" do
                file "#{"WikipediaFoo".underscore}.yml" do
                  contains ":url: www.google.com"
              end
            end
            directory "#{APP_ROOT}/lib" do 
              directory "sites" do 
                file "#{"WikipediaFoo".underscore}.rb"
                directory "#{"WikipediaFoo".underscore}" do 
                  directory "flows"
                  directory "pages" do 
                    directory "partials"
                  end
                end
              end
            end
            directory "#{APP_ROOT}/spec" do 
              directory "isolation" do 
                directory "#{"WikipediaFoo".underscore}"
              end
              directory "support" do 
                directory "#{"WikipediaFoo".underscore}"
              end
            end
          }
        end
end


describe Site, "arguments NAME URL" do 
  include GeneratorSpec::TestCase
  include Helpers::Taza
  destination APP_ROOT

    arguments ['BingFoo', 'http://bing.com']

    before :all do
      @site_name = "BingFoo"
    end

    before :each do
      bare_setup
      prepare_destination
      run_generator
    end

    after :each do
      bare_teardown
    end

      specify do
          destination_root.should have_structure {
            directory "#{APP_ROOT}/config" do
                file "#{"BingFoo".underscore}.yml" do
                  contains ":url: http://bing.com"
              end
            end
            directory "#{APP_ROOT}/lib" do 
              directory "sites" do 
                file "#{"BingFoo".underscore}.rb"
                directory "#{"BingFoo".underscore}" do 
                  directory "flows"
                  directory "pages" do 
                    directory "partials"
                  end
                end
              end
            end
            directory "#{APP_ROOT}/spec" do 
              directory "isolation" do 
                directory "#{"BingFoo".underscore}"
              end
              directory "support" do 
                directory "#{"BingFoo".underscore}"
              end
            end
          }
        end

end

describe Site, "no arguments" do 
  include GeneratorSpec::TestCase
  include Helpers::Taza
  destination APP_ROOT

    it "outputs an error message" do 
     output = capture(:stderr) { run_generator }
     output.should include("No value provided for required arguments 'name'")
    end
end

describe "valid site" do 
  include GeneratorSpec::TestCase
  include Helpers::Generator
  include Helpers::Taza
  destination APP_ROOT
  
    before :all do 
      @site_name = "valid"
    end
    
    it "generated site that uses the block given in new" do
      def generate_site(site_name) 
        site_name = "#{site_name}#{Time.now.to_i}"
        run_generator('site', site_name)
        site_file_path = File.join(PROJECT_FOLDER,'lib','sites',"#{site_name.underscore}.rb")
        require site_file_path
        "::#{site_name.camelize}::#{site_name.camelize}".constantize.any_instance.stubs(:base_path).returns(PROJECT_FOLDER)
        site_name.camelize.constantize
      end

        @site_class = generate_site(@site_name)
        stub_settings
        stub_browser
        foo = nil
        @site_class.new {|site| foo = site}
        foo.should_not be_nil
        foo.should be_a_kind_of(Taza::Site)
    end

end
