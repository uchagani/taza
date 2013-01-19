require 'spec_helper'
require 'rubygems'
require 'fileutils'
include Helpers::Taza

describe 'taza site generator' do 

  describe "running with NAME argument" do
      before :all do 
        @site_name = 'Gap'
        #clean
        thor("taza site #{@site_name}") 
      end     

    it "should create the site" do 
            sandbox.should have_structure {
              directory "config" do
                  file "#{@site_name}.underscore}.yml" do
                    contains ":url: www.google.com"
                end
              end
              directory "lib" do 
                directory "sites" do 
                  file "#{@site_name.underscore}.rb"
                  directory "#{@site_name.underscore}" do 
                    directory "flows"
                    directory "pages" do 
                      directory "partials"
                    end
                  end
                end
              end
              directory "spec" do 
                directory "isolation" do 
                  directory "#{@site_name.underscore}"
                end
                directory "support" do 
                  directory "#{@site_name.underscore}"
                end
              end
            }
        end
    end
end




# describe Site, "arguments NAME URL" do 
#   include GeneratorSpec::TestCase
#   include Helpers::Taza
#   destination APP_ROOT

#     arguments ['BingFoo', 'http://bing.com']

#     before :all do
#       @site_name = "BingFoo"
#     end

#     before :each do
#       bare_setup
#       prepare_destination
#       run_generator
#     end

#     after :each do
#       bare_teardown
#     end

#       specify do
#           destination_root.should have_structure {
#             directory "#{APP_ROOT}/config" do
#                 file "#{"BingFoo".underscore}.yml" do
#                   contains ":url: http://bing.com"
#               end
#             end
#             directory "#{APP_ROOT}/lib" do 
#               directory "sites" do 
#                 file "#{"BingFoo".underscore}.rb"
#                 directory "#{"BingFoo".underscore}" do 
#                   directory "flows"
#                   directory "pages" do 
#                     directory "partials"
#                   end
#                 end
#               end
#             end
#             directory "#{APP_ROOT}/spec" do 
#               directory "isolation" do 
#                 directory "#{"BingFoo".underscore}"
#               end
#               directory "support" do 
#                 directory "#{"BingFoo".underscore}"
#               end
#             end
#           }
#         end

# end

# describe Site, "no arguments" do 
#   include GeneratorSpec::TestCase
#   include Helpers::Taza
#   destination APP_ROOT

#     it "outputs an error message" do 
#      output = capture(:stderr) { run_generator }
#      output.should include("No value provided for required arguments 'name'")
#     end
# end

# describe Site, "valid site" do 
#   include GeneratorSpec::TestCase
#   include Helpers::Taza
#   destination APP_ROOT

#   arguments ["valid#{Time.now.to_i}"]

#     before :each do
#       bare_setup
#       prepare_destination
#       run_generator
#     end

#     after :each do
#       bare_teardown
#     end 
    
#     it "generated site that uses the block given in new" do
#         site_name = "valid#{Time.now.to_i}"
#         @site_class = generate_site(site_name)
#         stub_settings
#         stub_browser
#         foo = nil
#         @site_class.new {|site| foo = site}
#         foo.should_not be_nil
#         foo.should be_a_kind_of(Taza::Site)
#     end

# end
