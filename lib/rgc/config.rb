module Rgc
  class Config
    PATH = '.rgc.yml'

    def initialize(opts={})
      if File.exists?(PATH)
        abort "Not valid config file #{PATH}" unless config.is_a?(Hash)
      else
        create_new_config(rgc_key_file: opts[:key_file])
      end
    end

    def update(hash)
      unless hash.is_a?(Hash)
        abort "Cannot update config. Invalid options given."
      end

      File.open(path, 'w') do |f|
        YAML::dump(hash, f)
      end
    end

    def path
      if File.exists?(PATH)
        PATH
      else
        abort "Config file `#{PATH}` does not exist."
      end
    end

    def config
      YAML.load_file(path)
    end

    def create_new_config(init_value)
      File.open(PATH, 'w') do |f|
        YAML::dump(init_value, f)
      end
    end
  end
end
