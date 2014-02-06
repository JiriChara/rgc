require 'spec_helper'

describe Rgc::Init do
  context :initialize do
    it 'should abort when no key file given' do
      stderr = capture_stderr do
        lambda { Rgc::Init.new({}, {}, []) }.should raise_error(SystemExit)
      end
      stderr.should == "Key file must be given!\n"
    end
  end
end
