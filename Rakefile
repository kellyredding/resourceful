require 'rubygems'
require 'rake/gempackagetask'
require 'rake/testtask'

require 'lib/resourceful/version'

task :default => :test

spec = Gem::Specification.new do |s|
  s.name             = 'kelredd-resourceful'
  s.version          = Resourceful::Version.to_s
  s.has_rdoc         = true
  s.extra_rdoc_files = %w(README.rdoc)
  s.rdoc_options     = %w(--main README.rdoc)
  s.summary          = "A ruby gem to abstract web resource handling."
  s.author           = 'Kelly Redding'
  s.email            = 'kelly@kelredd.com'
  s.homepage         = ''
  s.files            = %w(README.rdoc Rakefile) + Dir.glob("{lib}/**/*")
  # s.executables    = ['resourceful']
  
  s.add_dependency('nokogiri')
  s.add_dependency('json')
  s.add_dependency('rest-client')
  s.add_dependency('mechanize')
  s.add_dependency('log4r')
  s.add_dependency('kelredd-useful', [">= 0.2.5"])

  s.add_development_dependency("shoulda", [">= 2.10.2"])
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
task :gemspec do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, 'w') {|f| f << spec.to_ruby }
  puts "Created gemspec: #{file}"
end
