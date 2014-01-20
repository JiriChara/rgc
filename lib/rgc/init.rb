module Rgc
  class Init
    def initialize(global_options, options, args)
      abort "Key file must be given!" if (key_file = args.first).nil?

      @secret = File.read(key_file)

      stdout, stderr, status = Open3.capture3("git status  -uno --porcelain")

      unless status.exitstatus == 0
        abort "git status failed - is this a git repository?"
      end

      unless stdout.length == 0
        $stderr.puts "Working directory not clean"
        abort "Please commit your changes or 'git stash' them."
      end
    end
  end
end
