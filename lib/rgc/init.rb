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
        STDERR.puts "Working directory not clean"
        abort "Please commit your changes or 'git stash' them."
      end

      stdout, stderr, status = Open3.capture3("git rev-parse --show-prefix")
      if stdout.strip != ""
        abort "Not in top-level of repository"
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

      # Do a force checkout so any files that were previously checked out
      # encrypted will now be checked out decrypted.
      # If HEAD doesn't exist (perhaps because this repo doesn't have any files
      # yet) just skip checkout
      out, err, status = Open3.capture3("git rev-parse HEAD >/dev/null 2>/dev/null")
      if status == 0
        out, err, status = Open3.capture3("git checkout -f HEAD -- .")
      end
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
      smudge = "git config filter.rgc.smudge \"rgc smudge\""
      stdout, stderr, status_smudge = Open3.capture3(smudge)

      clean = "git config filter.rgc.clean \"rgc clean\""
      stdout, stderr, status_clean = Open3.capture3(clean)

      diff = "git config diff.rgc.textconv \"rgc diff\""
      stdout, stderr, status_diff = Open3.capture3(diff)

      if [0, 0, 0] != [status_smudge, status_clean, status_diff]
        abort "Cannot configure git."
      end
    rescue Errno::ENOENT
      abort "Cannot configure git."
    end
  end
end
