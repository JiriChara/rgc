module Rgc
  class Clean
    include Rgc::KeyFile

    def initialize(global_options, options, args)
      load_key

      print(encrypt(ARGF.read))
    end

    def encrypt(content)
      @aes = OpenSSL::Cipher.new("AES-128-CBC")
      @aes.encrypt
      @aes.key = @key
      # TODO: consinder to set @aes.iv

      Base64.encode64(@aes.update(content) + @aes.final)
    end
  end
end
