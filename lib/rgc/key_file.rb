module Rgc
  module KeyFile
    def load_key
      # TODO: rescue from errors
      @key = File.read(YAML.load_file(Rgc::Encrypt::CONFIG)[:rgc_key_file])
    end
  end
end
