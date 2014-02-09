module Rgc
  class Smudge
    include Rgc::KeyFile

    def initialize(global_options, options, args)
      load_key

      print(decrypt(ARGF.read))
    end

    def decrypt(content)
      @aes = OpenSSL::Cipher.new("AES-128-CBC")
      @aes.decrypt
      @aes.key = @key

      STDOUT.print(@aes.update(Base64.decode64(content)) + @aes.final)
    end
  end
end
