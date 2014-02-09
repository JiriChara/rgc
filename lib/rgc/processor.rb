module Rgc
  class Processor
    class << self
      include Rgc::KeyFile

      def encrypt(content)
        load_key

        @aes = OpenSSL::Cipher.new("AES-128-CBC")
        @aes.encrypt
        @aes.key = @key
        # TODO: consinder to set @aes.iv

        "*@rgc@*-#{Base64.encode64(@aes.update(content) + @aes.final)}"
      end

      def decrypt(content)
        load_key

        @aes = OpenSSL::Cipher.new("AES-128-CBC")
        @aes.decrypt
        @aes.key = @key
        # TODO: consinder to set @aes.iv

        begin
          @aes.update(Base64.decode64(content)) + @aes.final
        rescue
          abort "Cannot decrypt file."
        end
      end
    end
  end
end
