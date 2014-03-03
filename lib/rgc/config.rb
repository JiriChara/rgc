module Rgc
  class Config
    PATH                       = '.rgc.yml'
    DEFAULT_GITATTRIBUTES_PATH = '.git/info/attributes'

    class << self
      def create(key_file, opts={})
        unless File.exists?(key_file)
          abort "Key file #{key_file} does not exist."
        end

        gitattributes_location = if opts[:gitattributes_location] == "root"
          ".gitattributes"
        else
          DEFAULT_GITATTRIBUTES_PATH
        end

        File.open(Rgc::Config::PATH, 'w') do |f|
          YAML::dump({
            rgc_key_file: key_file,
            gitattributes_location: gitattributes_location
          }, f)
        end

        self.new
      end
    end

    def initialize(opts={})
      if File.exists?(path)
        abort "Not valid config file #{PATH}" unless valid_config?
      end
    end

    def update(hash, opts={})
      unless hash.is_a?(Hash)
        abort "Cannot update config. Invalid options given."
      end

      if opts[:paths_only] == true
        hash = {
          rgc_key_file: key_file_path,
          gitattributes_location: gitattributes_location,
          paths: hash
        }
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

    # Get the whole content of config as a hash
    def config
      YAML.load_file(path)
    end

    def valid_config?
      config.is_a?(Hash) && !config[:rgc_key_file].nil?
    end

    # Get path to the key used for encryption.
    def key_file_path
      config[:rgc_key_file]
    end

    # Returns all paths with configured options
    #
    # Example of return value:
    #     {
    #       '*.secret' => '',
    #       'db.yml'   => '--yaml production.password,beta.password'
    #     }
    def paths
      config[:paths] || {}
    end

    def gitattributes_location
      config[:gitattributes_location] || DEFAULT_GITATTRIBUTES_PATH
    end
  end
end
