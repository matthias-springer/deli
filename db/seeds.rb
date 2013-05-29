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
require "app/models/lecture"
require "app/models/studentgroup"


MaglevRecord.reset

User.clear

st1 = User.create({
  :first_name => "User1",
  :last_name => "Test1",
  :email => "student1@test.com",
  :password => "pass"
  })
st2 = User.create({
  :first_name => "User2",
  :last_name => "Test2",
  :email => "student2@test.com",
  :password => "pass"
  })
st3 = User.create({
  :first_name => "User3",
  :last_name => "Test3",
  :email => "student3@test.com",
  :password => "pass"
  })
st4 = User.create({
  :first_name => "User4",
  :last_name => "Test4",
  :email => "student4@test.com",
  :password => "pass"
  })
st5 = User.create({
  :first_name => "User5",
  :last_name => "Test5",
  :email => "student5@test.com",
  :password => "pass"
  })

admin = User.create({
  :first_name => "Admin",
  :last_name => "Test",
  :email => "admin@test.com",
  :password => "pass"
  })

lecturer = User.create({
  :first_name => "Lecturer",
  :last_name => "Test",
  :email => "lecturer@test.com",
  :password => "pass"
  })

tut1 = User.create({
  :first_name => "Tutor1",
  :last_name => "Test",
  :email => "tutor1@test.com",
  :password => "pass"
  })
tut2 = User.create({
  :first_name => "Tutor2",
  :last_name => "Test",
  :email => "tutor2@test.com",
  :password => "pass"
  })

admin.set_role(:admin)
lecturer.set_role(:admin)
tut1.set_role(:tutor)
tut2.set_role(:tutor)

[st1, st2, st3, st4, st5, admin, lecturer, tut1, tut2, ].each do |user|
  user.clear_sensibles
end


lec1 = Lecture.create({
  :title => "Lecture 1",
  :description => "something",
  })

lec2 = Lecture.create({
  :title => "Lecture 2",
  :description => "something",
  })

lec3 = Lecture.create({
  :title => "Lecture 3",
  :description => "something",
  })


group1 = Studentgroup.new(:name => "Gruppe2")
group2 = Studentgroup.new(:name => "Gruppe4")

group1.students << st1
group1.students << admin
group1.students << st3
group1.students << st5
group1.tutors << tut1

group2.students << st2
group2.students << st3
group2.students << st4
group2.tutors << tut2

lec1.lecturers << lecturer
lec2.lecturers << lecturer
lec3.lecturers << lecturer

group2.lecture = lec1
group1.lecture = lec2

lec1.tutors << tut1
lec1.tutors << tut2

lec2.tutors << tut1
lec2.tutors << tut2

MaglevRecord.save
