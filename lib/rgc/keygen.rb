module Rgc
  class Keygen
    def initialize(global_options, options, args)
    end

    def generate(type=:base_64, range=1024)
      SecureRandom.send(type, range)
    end
  end
end
