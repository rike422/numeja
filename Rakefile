require 'rubygems'
require 'rake'
require 'bundler/gem_tasks'
require 'rake/testtask'

begin
  require 'bundler/setup'
rescue LoadError => e
  abort e.message
end

Rake::TestTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'yard'
YARD::Rake::YardocTask.new
task doc: :yard

task default: %i[test yard]
