# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "die"
  gem.homepage = "http://github.com/unclebilly/die"
  gem.license = "MIT"
  gem.summary = %Q{Kill one or more processes by command name}
  gem.description = %Q{Kill one or more processes by command name via an interactive script.  Die will find processes that match a given command name, and give you the opportunity to kill one, several, all, or none of them.}
  gem.email = "billy.reisinger@gmail.com"
  gem.authors = ["Billy Reisinger"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test