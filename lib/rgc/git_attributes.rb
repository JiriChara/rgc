module Rgc
  class GitAttributes
    attr_reader :location, :file

    def initialize
      @config   = Rgc::Config.new

      unless File.exists?(@location = @config.gitattributes_location)
        abort '.gitattributes file not found. Please run `rgc init` first.'
      end
    end

    def content
      File.read(@location)
    end
  end
end
