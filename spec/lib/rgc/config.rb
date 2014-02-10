require 'spec_helper'

describe Rgc::Keygen do
  before(:all) do
    @path = "/tmp/#{SecureRandom.hex(32)}.yml"

    @hash = {
      foo: 'bar'
    }

    File.open(@path, 'w') do |f|
      YAML::dump(@hash, f)
    end
  end

  after(:all) do
    File.delete(@path)
  end

  context :initialize do
    it 'should set `path` instance variable if given' do
      config = Rgc::Config.new(path: @path)
      config.instance_variable_get(:@path).should eq(@path)
    end

    it 'should default `path` to `.rgc.yml`' do
      Rgc::Config.any_instance.stub(:abort)
      YAML.stub(:load_file)

      Rgc::Config.new.instance_variable_get(:@path).should eq('.rgc.yml')
    end

    it 'should abort when config file does not exist' do
      path = '/this/file/does/not/exists.yml'

      stderr = capture_stderr do
        expect {
          Rgc::Config.new(path: path)
        }.to raise_error(SystemExit)
      end

      stderr.should eq("Config file `#{path}` does not exist.\n")
    end

    it 'should set `config` instance variable to content of file' do
      Rgc::Config.new(path: @path).instance_variable_get(:@config).should
        eq(@hash)
    end

    it 'should abort when config is not valid yaml file' do
      File.open(wrong_file = "/tmp/#{SecureRandom.hex(32)}.yml", 'w')

      stderr = capture_stderr do
        expect {
          Rgc::Config.new(path: wrong_file)
        }.to raise_error(SystemExit)
      end

      stderr.should eq("Not valid config file #{wrong_file}\n")

      File.delete(wrong_file)
    end
  end

  context :update do
    it 'should abort when file does not exist' do
      path = "/tmp/#{SecureRandom.hex(32)}.yml"

      File.open(path, 'w') do |f|
        YAML::dump({}, f)
      end

      config = Rgc::Config.new(path: path)

      File.delete(path)

      stderr = capture_stderr do
        expect {
          config.update({})
        }.to raise_error(SystemExit)
      end

      stderr.should eq("Config file `#{path}` does not exist.\n")
    end

    it 'should abort when hash not given' do
      stderr = capture_stderr do
        expect {
          Rgc::Config.new(path: @path).update("invalid")
        }.to raise_error(SystemExit)
      end

      stderr.should eq("Cannot update config. Invalid options given.\n")
    end

    it 'should update config file' do
      config = Rgc::Config.new(path: @path)

      config.update(cfg = {new: "value"})

      config.config.should eq(cfg)
    end
  end

  context :path do
    it 'should raise error when file does not exist' do
      path = "/dont/exist"

      stderr = capture_stderr do
        expect {
          Rgc::Config.new(path: path).path
        }.to raise_error(SystemExit)
      end

      stderr.should eq("Config file `#{path}` does not exist.\n")
    end
  end

  context :config do
    it 'should invoke load_file of YAML' do
      config = Rgc::Config.new(path: @path)

      YAML.should_receive(:load_file).with(config.path)
      config.config
    end

    it 'should call `path` method' do
      config = Rgc::Config.new(path: @path)

      config.should_receive(:path).and_return(@path)
      config.config
    end
  end
end
