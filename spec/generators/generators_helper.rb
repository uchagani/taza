module Helpers
  module Generator
    include FileUtils

      def setup
          mkdir_p(APP_ROOT)
      end 

      def clean
        rm_rf  TMP_ROOT || APP_ROOT
      end


      def capture(*streams)
        streams.map! { |stream| stream.to_s }
        begin
          result = StringIO.new
          streams.each { |stream| eval "$#{stream} = result" }
          yield
        ensure
          streams.each { |stream| eval("$#{stream} = #{stream.upcase}") }
        end
        result.string
      end

      def run(command)
        mkdir_p sandbox
        cd(sandbox) do
          system("#{command}")
        end
      end
      
      def thor(args)
        run("thor #{args}")
      end


      def generate_site(site_name)
       # site_name = "#{site_name}#{Time.now.to_i}"
        thor("site #{site_name}")
        site_file_path = File.join(PROJECT_FOLDER,'lib','sites',"#{site_name.underscore}.rb")
        require site_file_path
        "::#{site_name.camelize}::#{site_name.camelize}".constantize.any_instance.stubs(:base_path).returns(PROJECT_FOLDER)
        site_name.camelize.constantize
      end

   end 
end