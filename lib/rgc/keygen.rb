module Rgc
  class Keygen
    def initialize(global_options, options, args)
      @type  = options[:type]  || :base64
      @range = options[:range] || 512

      if File.exists?(path = args.first)
        raise ArgumentError, "Key file already exists."
      end

      File.open(path, 'w') do |f|
        f.write(generate_secure_key)
      end
    end

    def generate_secure_key
      SecureRandom.send(@type, @range)
    end
  end
end
