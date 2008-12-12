module Taza
  class Fixture

    def initialize
      @fixtures = {}
    end

    def load_all
      Dir.glob(fixtures_pattern) do |file|
        entitized_fixture = {}
        YAML.load_file(file).each do |key, value|
          entitized_fixture[key] = value.convert_hash_keys_to_methods(self)
        end
        @fixtures[File.basename(file,'.yml').to_sym] = entitized_fixture
      end
    end
    
    def fixture_names
      @fixtures.keys
    end
    
    def get_fixture_entity(fixture_file_key,entity_key)
      @fixtures[fixture_file_key][entity_key]
    end

    def pluralized_fixture_exists?(singularized_fixture_name)
      fixture_names.include?(singularized_fixture_name.pluralize_to_sym)
    end

    def fixtures_pattern
      File.join(base_path, 'fixtures','*.yml')
    end

    def base_path
      File.join('.','spec')
    end
  end
  
  module Fixtures
    def Fixtures.included(other_module)
      fixture = Fixture.new
      fixture.load_all
      fixture.fixture_names.each do |fixture_name|
        self.class_eval do
          define_method(fixture_name) do |entity_key|
            fixture.get_fixture_entity(fixture_name,entity_key.to_s)
          end
        end
      end
    end
  end

end