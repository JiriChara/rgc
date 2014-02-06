require 'rgc/version.rb'

require 'open3'
require 'yaml'

require 'gli'

module Rgc
  autoload :Keygen,    'rgc/keygen'
  autoload :Init,      'rgc/init'
  autoload :Encrypt,   'rgc/encrypt'
  autoload :ArgParser, 'rgc/arg_parser'
end
