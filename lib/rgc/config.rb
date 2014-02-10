module Rgc
  class Config
    def initialize(opts={})
      @path = opts[:path] || '.rgc.yml'

      if File.exists?(@path)
        abort "Not valid config file #{@path}" unless config.is_a?(Hash)
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
      if File.exists?(@path)
        @path
      else
        abort "Config file `#{@path}` does not exist."
      end
    end

    def config
      YAML.load_file(path)
    end

    def create_new_config(init_value)
      File.open(@path, 'w') do |f|
        YAML::dump(init_value, f)
      end
    end
  end
end
