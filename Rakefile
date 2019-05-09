require_relative './config/environment'
require 'sinatra/activerecord/rake'

desc 'starts a console'
task :console do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  Pry.start
end

desc 'run the program'
task :run do
  puts "Running SMARTER CLASSIFIEDS"
  ruby "bin/run.rb"
end

desc 'creates and seeds db'
task :setup_db do
  puts "Initializing database..."
  puts "Creating tables..."
  Rake::Task["db:migrate"].invoke
  puts
  puts "Seeding tables..."
  Rake::Task["db:seed"].invoke
  puts "...Done"
  puts
end
