require "maglev_record"

class Lecture
  include MaglevRecord::RootedBase

  attr_accessor :title, :description
  attr_accessor :lecturers, :staff_members, :tutors, :students
  attr_accessor :assignments

  validates :title, :presence => true
  validates :description, :presence => true

  def to_s
    "#{title}, #{description}"
  end

  def initialize(*args)
    super(*args)
    self.lecturers = []
    self.staff_members = []
    self.tutors = []
    self.students = []
  end

  def valid_role(role)
    return [:lecturer, :staff_member, :tutor, :student].include?(role.to_sym)
  end
  private :valid_role

  def add_user(user, role)
    return false if not valid_role(role)
    persons = attributes[pluralize(role)] # pluralizing role
    persons << user unless persons.include?(user)
    true
  end
  def remove_user(user, role)
    return false if not valid_role(role)
    attributes[pluralize(role)].delete(user)
    true
  end
  def add_student(student)
    add_user(student, :student)
  end
  def remove_student(student)
    remove_user(student, :student)
  end

  def groups
    Studentgroup.find_all { |group| group.lecture == self }
  end

  private
  def pluralize(role)
    (role.to_s + "s").to_sym
  end
end

Lecture.maglev_record_persistable
MaglevRecord.save
Lecture.redo_include_and_extend
