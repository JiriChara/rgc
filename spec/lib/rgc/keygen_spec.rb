require 'spec_helper'

describe Rgc::Keygen do
  context :initialize do
    it 'should set `type` instance variable if given' do
      File.stub(open: true)
      File.stub(exists?: false)

      keygen = Rgc::Keygen.new({}, { type: "hex" }, [""])
      keygen.instance_variable_get(:@type).should eq("hex")
    end

    it 'should set `range` instance variable if given' do
      File.stub(open: true)
      File.stub(exists?: false)

      keygen = Rgc::Keygen.new({}, { range: 32 }, [""])
      keygen.instance_variable_get(:@range).should eq(32)
    end

    it 'should abort when key file not exists' do
      File.open(file = "/tmp/#{SecureRandom.hex(32)}", "w")

      expect {
        Rgc::Keygen.new({}, {}, [file])
      }.to raise_error(SystemExit)

      File.delete(file)
    end

    it 'should abort when file cannot be opened for writing' do
      expect {
        Rgc::Keygen.new({}, {}, ["/this/file/does/not/exist"])
      }.to raise_error(SystemExit)
    end
  end
end
