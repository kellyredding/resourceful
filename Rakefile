require 'rubygems'
require 'rake/gempackagetask'
require 'rake/testtask'

require 'lib/resourceful/version'

task :default => :test

spec = Gem::Specification.new do |s|
  s.name             = 'resourceful'
  s.version          = Resourceful::Version.to_s
  s.has_rdoc         = true
  s.extra_rdoc_files = %w(README.rdoc)
  s.rdoc_options     = %w(--main README.rdoc)
  s.summary          = "A ruby gem to abstract web resource handling."
  s.author           = 'Kelly Redding'
  s.email            = 'kelly@kelredd.com'
  s.homepage         = ''
  s.files            = %w(README.rdoc Rakefile) + Dir.glob("{features,lib,test}/**/*")
  # s.executables    = ['resourceful']
  
  s.add_dependency('nokogiri')
  s.add_dependency('json')
  s.add_dependency('rest_client')
  s.add_dependency('log4r')
  s.add_dependency('kelredd-useful')
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

desc 'Generate the gemspec to serve this Gem from Github'
task :github do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, 'w') {|f| f << spec.to_ruby }
  puts "Created gemspec: #{file}"
end

require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty" 
end
