module Rgc
  class Encrypt
    def initialize(global_options, options, args)
      @config        = Rgc::Config.new
      @encrypt       = @config.paths
      @gitattributes = GitAttributes.new

      determine_encryption(args, options)

      @config.update(@encrypt)


      # File.open(@config.gitattributes_location, 'a') do |f|
      #   @encrypt.each do |k, v|
      #     f.puts("#{k} filter=rgc diff=rgc")
      #   end
      # end
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
  end
end
