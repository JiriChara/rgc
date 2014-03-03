module Rgc
  class Encrypt
    def initialize(global_options, options, args)
      @config        = Rgc::Config.new
      @encrypt       = {}
      @gitattributes = GitAttributes.new

      if options[:password] == true && !options[:string].nil?
        abort "You can't pass --password and --string together. Choose one!" 
      end

      @string = if options[:password] == true
        get_password
      elsif !options[:string].nil?
        options[:string]
      else
        ""
      end

      proceed_paths(args, options)

      @config.update(@encrypt.merge(@config.paths), paths_only: true)

      @encrypt.each do |k, v|
        @gitattributes.add(k)
      end
    end

    def get_password
      ask("Enter string (password): ") { |q| q.echo = '*' }
    end

    def proceed_paths(args, options)
      args.each do |arg|
        @encrypt[arg] = if @string.empty?
          @string
        else
          Rgc::Processor.new.encrypt(@string)
        end
      end
    end
  end
end
