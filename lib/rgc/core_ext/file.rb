class File
  def encrypted?
    read.match(/#{Rgc::Processor::PREFIX}\w+#{Rgc::Processor::SUFFIX}/) != nil
  end
end
