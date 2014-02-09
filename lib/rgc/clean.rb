module Rgc
  class Clean
    def initialize(global_options, options, args)
      STDOUT.write(encrypt(ARGF.read))
    end

    def encrypt(content)
      Rgc::Processor.encrypt(content)
    end
  end
end
