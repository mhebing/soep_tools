require "bundler/gem_tasks"

desc "Start IRB session."
task :irb do
  require 'irb'
  require 'irb/completion'
  require 'soep_tools' # You know what to do.
  ARGV.clear
  IRB.start
end

desc "Start PRY session."
task :pry do
  require 'pry'
  require 'my_gem'
  ARGV.clear
  Pry.start
end
