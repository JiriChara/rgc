module Rgc
  class ArgParser
    include GLI::App

    def initialize(argv, argf)
      program_desc 'Program to encrypt certain files inside git repository.'

      version Rgc::VERSION

      pre do |global,command,options,args|
        # Pre logic here
        # Return true to proceed; false to abort and not call the
        # chosen command
        # Use skips_pre before a command to skip this block
        # on that command only
        true
      end

      post do |global,command,options,args|
        # Post logic here
        # Use skips_post before a command to skip this
        # block on that command only
      end

      on_error do |exception|
        # Error logic here
        # return false to skip default error handling
        true
      end

      exit run(ARGV)
    end

    def init_clean
    end

    def init_smudge
    end
    
    def init_keygen
      desc('generate a rbc key in the given file')

      command(:keygen) do |c|
        c.action do |global_options, options, args|
          Rgc::Keygen.new(global_options, options, args)
        end
      end
    end

    def init_encrypt
    end
  end
end
