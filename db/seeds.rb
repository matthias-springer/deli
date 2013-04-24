# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)
require "rubygems"
require "maglev_record"
require "app/models/user"


MaglevRecord.reset

User.clear
User.create({
  :first_name => "User",
  :last_name => "Test",
  :email => "user@test.com",
  :password => "password"
  })

MaglevRecord.save