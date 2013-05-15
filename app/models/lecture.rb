require "maglev_record"

class Lecture
  include MaglevRecord::RootedBase

  attr_accessor :title, :description
  attr_accessor :lecturers, :staff_members, :tutors, :students

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
    return [:lecturer, :staff_member, :tutor].include?(role.to_sym)
  end
  private :valid_role

  def add_user(user, role)
    return false if not valid_role(role)
    persons = attributes[(role.to_s + "s").to_sym] # pluralizing role
    persons << user unless persons.include?(user)
    true
  end
  def remove_user(user, role)
    return false if not valid_role(role)
    lecture.attributes[role].delete(user)
    true
  end

  def groups
    Studentgroup.find_all { |group| group.lecture == self }
  end
end

Lecture.maglev_record_persistable
MaglevRecord.save
Lecture.redo_include_and_extend
