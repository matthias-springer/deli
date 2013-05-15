#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

require 'maglev_record/raketasks'

Deli::Application.load_tasks

namespace :test do
  task :prepare do
    stone_name = if ENV["TRAVIS"] then "maglev" else "test" end
    ENV["MAGLEV_OPTS"] ||= ""
    ENV["MAGLEV_OPTS"] += " -W0 --stone #{stone_name}"
  end
end

