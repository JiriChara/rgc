module Rgc
  class Init
    def initialize(global_options, options, args)
      abort "Key file must be given!" if (@key_file = args.first).nil?

      begin
        @secret = File.read(@key_file)
      rescue
        abort "Cannot read key file #{@key_file}"
      end

      begin
        stdout, stderr, status = Open3.capture3("git status  -uno --porcelain")
      rescue Errno::ENOENT
        abort "Cannot run `git status  -uno --porcelain`."
      end

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

      add_git_config_options
    end

    def init_rgc_config_file
      @config = Rgc::Encrypt::CONFIG

      if File.exists?(@config)
        validate_config_file(@config)
      else
        File.open(@config, 'w') { |f| YAML::dump({ rgc_key_file: @key_file }, f) }
      end
    end

    def validate_config_file
      begin
        raise unless YAML.load_file(@config).is_a?(Hash)
      rescue
        abort("Invalid rgc config file (#{@config}). Delete it or fix it.")
      end
    end

    def add_git_config_options
      smudge = "git config filter.smudge rgc smudge"
      stdout, stderr, status_smudge = Open3.capture3(smudge)

      clean = "git config filter.clean rgc clean"
      stdout, stderr, status_clean = Open3.capture3(clean)

      if [0, 0] != [status_smudge, status_clean]
        abort "Cannot configure git."
      end
    rescue Errno::ENOENT
      abort "Cannot configure git."
    end
  end
end
