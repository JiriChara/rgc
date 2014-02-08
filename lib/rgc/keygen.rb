module Rgc
  class Keygen
    def initialize(global_options, options, args)
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

  private
    def generate_secure_key
      OpenSSL::Cipher.new("AES-128-CBC").random_key
    end
  end
end
