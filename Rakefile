require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
# require 'hoe'
# require File.dirname(__FILE__) << "/lib/resource_authentication/version"

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the resource_authentication plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

# Hoe.new("Resource Authentication", ResourceAuthentication::Version::String) do |p|
#   p.name = "resource_authentication"
#   p.author = "Simon Chiu"
#   p.email = "skhchiu@gmail.com"
#   p.summary = "An adaptation of Ben Johnson's (Binary Logic) excellent Authlogic library, but for ActiveResource"
#   p.description = "An authentication solution for working with ActiveResource"
#   p.url = "http://github.com/tolatomeow/Resource-Authentication"
#   # p.history_file = "CHANGELOG.rdoc"
#   # p.readme_file = "README.rdoc"
#   # p.extra_rdoc_files = ["CHANGELOG.rdoc", "README.rdoc"]
#   # p.remove_rdoc_dir = ''
#   p.test_globs = ["test/*/test_*.rb", "test/*_test.rb", "test/*/*_test.rb"]
#   p.extra_deps = %w(activesupport)
# end