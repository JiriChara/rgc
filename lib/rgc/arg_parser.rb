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

      init_keygen
      init_init
      init_encrypt

      exit run(ARGV)
    end

    def init_keygen
      desc('generate a rgc key in the given file')

      command(:keygen) do |c|

        c.flag [:type, :t],
          desc: "set the encryption type",
          must_match: ["base64", "hex"],
          default_value: "base64"

        c.flag [:range, :r],
          desc: "set the length of a key",
          type: Integer,
          default_value: 512

        c.action do |global_options, options, args|
          Rgc::Keygen.new(global_options, options, args)
        end
      end
    end

    def init_init
      desc('prepare git repository to use rgc with given key file')

      command(:init) do |c|

        c.action do |global_options, options, args|
          Rgc::Init.new(global_options, options, args)
        end
      end
    end

    def init_clean
    end

    def init_smudge
    end

    def init_encrypt
      desc('set files for encryption')

      command(:encrypt) do |c|

        c.flag [:yaml, :y], desc: "yaml values to encrypt"

        c.action do |global_options, options, args|
          Rgc::Encrypt.new(global_options, options, args)
        end
      end
    end
  end
end
