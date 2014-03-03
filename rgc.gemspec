# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','rgc','version.rb'])

spec = Gem::Specification.new do |s| 
  s.name    = 'rgc'
  s.version = Rgc::VERSION

  s.authors          = ['Jiri Chara']
  s.date             = Date.today
  s.email            = 'jirik.chara@gmail.com'
  s.homepage         = 'https://github.com/JiriChara/rgc'
  s.licenses         = ['MIT']
  s.require_paths    = ['lib']
  s.rubygems_version = '2.2.2'
  s.platform         = Gem::Platform::RUBY
  s.summary          = 'Tool for encrypting files in a git repository.'
  s.description      = 'rgc is a tool for encrypting certain files in a git repository.'

  s.has_rdoc         = true
  s.extra_rdoc_files = %w(
    README.rdoc
    LICENCE.txt
    rgc.rdoc
  )
  s.rdoc_options << '--title' << 'rgc' << '--main' << 'README.rdoc' << '-ri'

  s.files = Dir['LICENSE.txt', 'README.rdoc', 'lib/**/*']

  s.bindir = 'bin'
  s.executables << 'rgc'

  s.add_runtime_dependency('highline', '~> 1.6')

  s.add_development_dependency('rake',  '~> 10.1')
  s.add_development_dependency('rdoc',  '~> 4.1')
  s.add_development_dependency('aruba', '~> 0.5')
  s.add_development_dependency('rspec', '~> 2.14')
  s.add_development_dependency('faker', '~> 1.2')

  s.add_runtime_dependency('gli', '~> 2.8')
end
