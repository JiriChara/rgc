module Rgc
  class Init
    def initialize(global_options, options, args)
      abort "Key file must be given!" if (key_file = args.first).nil?

      begin
        @secret = File.read(key_file)
      rescue
        abort "Cannot read key file #{key_file}"
      end

      stdout, stderr, status = Open3.capture3("git status  -uno --porcelain")

      unless status.exitstatus == 0
        abort "git status failed - is this a git repository?"
      end

      unless stdout.length == 0
        $stderr.puts "Working directory not clean"
        abort "Please commit your changes or 'git stash' them."
      end

      init_rgc_config_file

      unless File.exist?('.gitattributes')
        begin
          File.open('.gitattributes', 'w') {}
        rescue Errno::EACCES
          abort "Cannot open .gitattributes for writing."
        end
      end
    end

    def init_rgc_config_file
      @config = Rgc::Encrypt::CONFIG

      if File.exists?(@config)
        validate_config_file(@config)
      else
        File.open(@config, 'w') { |f| YAML::dump({}, f) }
      end
    end

    def validate_config_file
      begin
        raise unless YAML.load_file(@config).is_a?(Hash)
      rescue
        abort("Invalid rgc config file (#{@config}). Delete it or fix it.")
      end
    end
  end
end
