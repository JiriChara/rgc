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

      Rgc::Keygen.any_instance.should_receive(:abort)
        .with("Key file already exists.")

      Rgc::Keygen.new({}, {}, [file])

      File.delete(file)
    end

    it 'should abort when file cannot be opened for writing' do
      path = "/this/file/does/not/exist"

      Rgc::Keygen.any_instance.should_receive(:abort)
        .with("Cannot open #{path} for writing.")

      Rgc::Keygen.new({}, {}, [path])
    end

    it 'should create a file and insert secure key to it' do
      file = "/tmp/#{SecureRandom.hex(32)}"

      Rgc::Keygen.new({}, {}, [file])

      File.read(file).length.should > 0

      File.delete(file)
    end
  end

  context :generate_secure_key do
    it 'should generate random key' do
      File.stub(open: true)
      File.stub(exists?: false)

      type  = :hex
      range = 5

      keygen = Rgc::Keygen.new({}, { type: type, range: range }, [""])

      ::SecureRandom.should_receive(type).with(range)
      keygen.send(:generate_secure_key)
    end
  end
end
