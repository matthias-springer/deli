require "maglev_record/migration"
require "time"

MaglevRecord::Migration.new(Time.parse('Wed May 29 12:17:20 +0000 2013'), 'fill in description here') do

  def up
    rename_class StudentGroup, :Studentgroup
    #new accessor :password_confirmation of User
    #new instance method: User.new.admin!
    #new instance method: User.new.full_name
    #new instance method: User.new.in_group?
    #new instance method: User.new.in_lecture?
    #new instance method: User.new.my_groups
    #new instance method: User.new.my_lectures
    #new instance method: User.new.no_admin!
    #new instance method: User.new.no_student!
    #new instance method: User.new.no_tutor!
    #new instance method: User.new.password_confirmation
    #new instance method: User.new.password_confirmation=
    #new instance method: User.new.student!
    #new instance method: User.new.tutor!
    User.remove_instance_method :password=
    Lecture.delete_attribute(:groups)
    Lecture.delete_attribute(:lecturer)
    Lecture.delete_attribute(:staff)
    #new accessor :lecturers of Lecture
    #new accessor :staff_members of Lecture
    #new instance method: Lecture.new.add_student
    #new instance method: Lecture.new.add_user
    #new instance method: Lecture.new.lecturers
    #new instance method: Lecture.new.lecturers=
    #new instance method: Lecture.new.remove_student
    #new instance method: Lecture.new.remove_user
    #new instance method: Lecture.new.staff_members
    #new instance method: Lecture.new.staff_members=
    Lecture.remove_instance_method :groups=
    Lecture.remove_instance_method :lecturer
    Lecture.remove_instance_method :lecturer=
    Lecture.remove_instance_method :staff
    Lecture.remove_instance_method :staff=
  end

  def down
    rename_class Studentgroup, :StudentGroup
    User.delete_attribute(:password_confirmation)
    #new instance method: User.new.password=
    User.remove_instance_method :admin!
    User.remove_instance_method :full_name
    User.remove_instance_method :in_group?
    User.remove_instance_method :in_lecture?
    User.remove_instance_method :my_groups
    User.remove_instance_method :my_lectures
    User.remove_instance_method :no_admin!
    User.remove_instance_method :no_student!
    User.remove_instance_method :no_tutor!
    User.remove_instance_method :password_confirmation
    User.remove_instance_method :password_confirmation=
    User.remove_instance_method :student!
    User.remove_instance_method :tutor!
    Lecture.delete_attribute(:lecturers)
    Lecture.delete_attribute(:staff_members)
    #new accessor :groups of Lecture
    #new accessor :lecturer of Lecture
    #new accessor :staff of Lecture
    #new instance method: Lecture.new.groups=
    #new instance method: Lecture.new.lecturer
    #new instance method: Lecture.new.lecturer=
    #new instance method: Lecture.new.staff
    #new instance method: Lecture.new.staff=
    Lecture.remove_instance_method :add_student
    Lecture.remove_instance_method :add_user
    Lecture.remove_instance_method :lecturers
    Lecture.remove_instance_method :lecturers=
    Lecture.remove_instance_method :remove_student
    Lecture.remove_instance_method :remove_user
    Lecture.remove_instance_method :staff_members
    Lecture.remove_instance_method :staff_members=
  end

end
