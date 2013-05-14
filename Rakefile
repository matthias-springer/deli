#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

require 'maglev_record/raketasks'

Deli::Application.load_tasks

Rake::Task["test:functionals"].clear

namespace :test do
  Rake::TestTask.new do |t|
    t.libs << 'test'
    t.name = 'functionals'
    t.test_files = FileList['test/functional/*.rb']
    t.ruby_opts << "-W0 -rubygems --stone test"
  end
end

