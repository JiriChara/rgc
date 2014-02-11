require 'rgc/version.rb'

require 'open3'
require 'yaml'
require 'openssl'
require 'base64'
require 'date'

require 'gli'

module Rgc
  autoload :KeyFile,   'rgc/key_file'
  autoload :Keygen,    'rgc/keygen'
  autoload :Init,      'rgc/init'
  autoload :Encrypt,   'rgc/encrypt'
  autoload :ArgParser, 'rgc/arg_parser'
  autoload :ArgParser, 'rgc/git_attributes'
  autoload :Config,    'rgc/config'
  autoload :Processor, 'rgc/processor'
  autoload :Clean,     'rgc/clean'
  autoload :Smudge,    'rgc/smudge'
  autoload :Diff,      'rgc/diff'
end
