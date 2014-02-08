require 'rgc/version.rb'

require 'open3'
require 'yaml'
require 'openssl'
require 'base64'

require 'gli'

module Rgc
  autoload :KeyFile,   'rgc/key_file'
  autoload :Keygen,    'rgc/keygen'
  autoload :Init,      'rgc/init'
  autoload :Encrypt,   'rgc/encrypt'
  autoload :ArgParser, 'rgc/arg_parser'
  autoload :Clean,     'rgc/clean'
  autoload :Smudge,    'rgc/smudge'
end
