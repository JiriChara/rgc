require 'rake/clean'
require 'rubygems'
require 'rubygems/package_task'
require 'rdoc/task'

Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc","lib/**/*.rb","bin/**/*")
  rd.title = 'Your application title'
end

spec = eval(File.read('rgc.gemspec'))

Gem::PackageTask.new(spec) do |pkg|
end

desc 'run Rspec specs'
task :spec do
  sh 'rspec spec'
end

task :default => [:spec, :package]
