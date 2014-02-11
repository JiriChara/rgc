require 'spec_helper'

describe Rgc::Config do
  before(:each) do
    @hash = {
      '*.secret'   => '',
      'secret.yml' => '--yaml production.password,mysql.password'
    }

    File.open(Rgc::Config::PATH, File::CREAT|File::TRUNC|File::WRONLY) do |f|
      YAML::dump(@hash, f)
    end
  end

  after(:each) do
    if File.exists?(Rgc::Config::PATH)
      File.unlink(Rgc::Config::PATH)
    end
  end

  it '`PATH` should eq `.rgc.yml`' do
    Rgc::Config::PATH.should eq('.rgc.yml')
  end

  context :initialize do
    it 'should abort when config is not valid yaml file' do
      File.open(".rgc.yml", 'w')

      stderr = capture_stderr do
        expect {
          Rgc::Config.new()
        }.to raise_error(SystemExit)
      end

      stderr.should eq("Not valid config file #{Rgc::Config::PATH}\n")
    end
  end

  context :update do
    it 'should abort when file does not exist' do
      config = Rgc::Config.new

      File.unlink(Rgc::Config::PATH)

      stderr = capture_stderr do
        expect {
          config.update({ '*.txt' => '' })
        }.to raise_error(SystemExit)
      end

      stderr.should eq("Config file `#{Rgc::Config::PATH}` does not exist.\n")
    end

    it 'should abort when hash not given' do
      stderr = capture_stderr do
        expect {
          Rgc::Config.new.update("invalid")
        }.to raise_error(SystemExit)
      end

      stderr.should eq("Cannot update config. Invalid options given.\n")
    end

    it 'should update config file' do
      config = Rgc::Config.new

      config.update(cfg = {new: "value"})

      config.config.should eq(cfg)
    end

    it 'should invoke path method' do
      cfg = Rgc::Config.new
      cfg.should_receive(:path).and_return(Rgc::Config::PATH)
      cfg.update({})
    end
  end

  context :path do
    it 'should raise error when file does not exist' do
      config = Rgc::Config.new
      File.unlink(Rgc::Config::PATH)

      stderr = capture_stderr do
        expect {
          config.path
        }.to raise_error(SystemExit)
      end

      stderr.should eq("Config file `#{Rgc::Config::PATH}` does not exist.\n")
    end
  end

  context :config do
    it 'should invoke load_file of YAML' do
      config = Rgc::Config.new

      YAML.should_receive(:load_file).with(config.path)
      config.config
    end

    it 'should invoke `path` method' do
      config = Rgc::Config.new

      config.should_receive(:path).and_return(Rgc::Config::PATH)
      config.config
    end
  end
end
