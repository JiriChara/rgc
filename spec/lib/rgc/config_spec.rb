require 'spec_helper'

describe Rgc::Config do
  before(:each) do
    @path_to_key = '/tmp/rgc.key'
    @hash = {
      :rgc_key_file => @path_to_key,
      '*.secret'    => '',
      'secret.yml'  => '--yaml production.password,mysql.password'
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

  context :create_new_config do
    it 'should create new config' do
      cfg = Rgc::Config.new
      File.delete(cfg.path)
      File.open(key =  '/tmp/rgc.key', 'w')

      cfg.send(:create_new_config, key)

      File.exists?(cfg.path).should eq(true)
    end

    it 'should abort when no key file given' do
      cfg = Rgc::Config.new

      path = '/I/dont/exist'
      stderr = capture_stderr do
        expect {
          cfg.send(:create_new_config, path)
        }.to raise_error(SystemExit)
      end

      stderr.should eq("Key file #{path} does not exist.\n")
    end

    it 'should be private' do
      cfg = Rgc::Config.new
      expect {
        cfg.create_new_config
      }.to raise_error(NoMethodError)
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

    it 'should return whole config as hash' do
      Rgc::Config.new.config.should eq(@hash)
    end
  end

  context :key_file_path do
    it 'should return path to key' do
      Rgc::Config.new.key_file_path.should eq(@path_to_key)
    end

    it 'should invoke config method' do
      cfg = Rgc::Config.new
      cfg.should_receive(:config).and_return(YAML.load_file(Rgc::Config::PATH))

      cfg.key_file_path
    end
  end

  context :paths do
    it 'should return paths for encryption' do
      @hash.delete(:rgc_key_file)

      Rgc::Config.new.paths.should eq(@hash)
    end

    it 'should invoke config method' do
      cfg = Rgc::Config.new
      cfg.should_receive(:config).and_return(YAML.load_file(Rgc::Config::PATH))

      cfg.paths
    end
  end
end
