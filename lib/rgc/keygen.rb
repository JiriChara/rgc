module Rgc
  class Keygen
    def initialize(global_options, options, args)
      @type  = options[:type]  || :base64
      @range = options[:range] || 512

      if File.exists?(path = args.first)
        abort "Key file already exists."
      end

      begin
        File.open(path, 'w') do |f|
          f.write(generate_secure_key)
        end
      rescue
        abort "Cannot open #{path} for writing."
      end
    end

    def generate_secure_key
      SecureRandom.send(@type, @range)
    end
  end
end
