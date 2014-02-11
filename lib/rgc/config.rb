module Rgc
  class Config
    PATH     = '.rgc.yml'
    KEY_FILE = :rgc_key_file

    def initialize(opts={})
      if File.exists?(PATH)
        abort "Not valid config file #{PATH}" unless config.is_a?(Hash)
      else
        create_new_config(opts[:key_file])
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

    def create_new_config(key_file)
      unless File.exists?(key_file)
        abort "Key file #{key_file} does not exist."
      end

      File.open(PATH, 'w') do |f|
        YAML::dump({ KEY_FILE => key_file }, f)
      end
    end
    private :create_new_config

    # Get the whole content of config as a hash
    def config
      YAML.load_file(path)
    end

    # Get path to the key used for encryption.
    def key_file_path
      config[KEY_FILE]
    end

    # Returns all paths with configured options
    #
    # Example of return value:
    #     {
    #       '*.secret' => '',
    #       'db.yml'   => '--yaml production.password,beta.password'
    #     }
    def paths
      cfg = config.dup
      cfg.delete(:rgc_key_file)
      cfg
    end
  end
end
