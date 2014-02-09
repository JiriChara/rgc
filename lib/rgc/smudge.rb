module Rgc
  class Smudge
    def initialize(global_options, options, args)
      STDOUT.write(decrypt(ARGF.read))
    end

    def decrypt(content)
      if content.gsub!(/^\*@rgc@\*-/, '') == nil
        abort 'File not encrypted.'
      end

      Rgc::Processor.decrypt(content)
    end
  end
end
