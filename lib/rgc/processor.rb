module Rgc
  class Processor
    PREFIX = "*@rgc@*\n"
    SUFFIX = "*@rgc@*"

    def initialize
      @key = File.read(Rgc::Config.new.key_file_path)

      @aes = OpenSSL::Cipher.new("AES-128-CBC")
    end

    def encrypt(content, value=nil)
      @aes.encrypt
      @aes.key = @key

      if value
        content.gsub(value, encrypt_string(value))
      else
        encrypt_string(content)
      end
    end

    def encrypt_string(str)
      "#{PREFIX}#{Base64.encode64(@aes.update(str) + @aes.final)}#{SUFFIX}"
    end

    def decrypt_string(str)
    end

    def decrypt(content)
      @aes.decrypt
      @aes.key = @key

      content.sub(/#{PREFIX}(\w+)#{SUFFIX}/) do
        decrypt_string($1)
      end
    end
  end
end
