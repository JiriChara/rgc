module Rgc
  class Diff
    include Rgc::KeyFile

    def initialize(global_options, options, args)
      load_key

      if content !~ /^\*@rgc@\*-/
        STDOUT.write(content)
      else
        content = content.gsub(/^\*@rgc@\*-/, '')
      end

      Rgc::Processor.decrypt(content)
    end
  end
end
