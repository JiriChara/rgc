module Rgc
  class GitAttributes
    attr_reader :location, :file

    def initialize
      @config   = Rgc::Config.new

      unless File.exists?(@location = @config.gitattributes_location)
        abort '.gitattributes file not found. Please run `rgc init` first.'
      end
    end

    # Get the content of the gitattributes file
    def content
      File.read(@location)
    rescue Errno::ENOENT
      abort "File #{@location} does not exists."
    rescue Errno::EACCES
      abort "File #{@location} is not accessible for writing."
    end

    # Add new path to the gitattributes file
    def add(path)
      str = "#{path} filter=rgc diff=rgc"
      if content.include?(str)
        abort "`#{str}\n` is already included in #{@location}."
      end

      File.open(@location, 'a') do |f|
        f.write("#{str}\n")
      end
    rescue Errno::ENOENT
      abort "File #{@location} does not exists."
    rescue Errno::EACCES
      abort "File #{@location} is not accessible for writing."
    end
  end
end
