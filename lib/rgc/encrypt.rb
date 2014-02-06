module Rgc
  class Encrypt
    CONFIG = '.rgc.yml'

    def initialize(global_options, options, args)
      load_rgc_config

      determine_encryption(args, options)

      save_new_config

      update_git_attributes
    end

    def determine_encryption(args, options)
      args.each do |arg|
        @encrypt[arg] = options.select do |k, v|
          k == :yaml && v != nil
        end

        @encrypt[arg] = if @encrypt[arg].empty?
          ""
        else
          a = []

          @encrypt[arg].each do |k,v|
            a << "--#{k} #{v}"
          end

          a.join(" ")
        end
      end
    end

    def load_rgc_config
      unless File.exists?(CONFIG)
        abort "#{CONFIG} not found. Please run `rgc init` first."
      end

      @encrypt = YAML.load_file(CONFIG)
    end

    def save_new_config
      f = File.open(CONFIG, 'w') do |f|
        YAML::dump(@encrypt, f)
      end
    end

    def update_git_attributes
      unless File.exists?('.gitattributes')
        abort '.gitattributes file not found. Please run `rgc init` first.'
      end

      File.open('.gitattributes', 'a') do |f|
        @encrypt.each do |k, v|
          f.puts("#{k} filter=rgc diff=rgc")
        end
      end
    end
  end
end
