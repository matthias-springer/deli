require "maglev_record"

class Lecture
  include MaglevRecord::RootedBase

  attr_accessor :title, :lecturer, :description, :students, :tutors, :staff

  validates :title, :presence => true
  validates :description, :presence => true

  def to_s
    "#{title}, #{description}"
  end

  def initialize(*args)
    super(*args)
    self.lecturer = []
    self.students = []
    self.tutors = []
    self.staff = []
  end

  def valid_role(role)
    return [:tutors, :lecturer, :staff].include?(role.to_sym)
  end
  private :valid_role

  def add_user(user, role)
    return false if not valid_role(role)
    persons = lecture.attributes[role]
    persons << user unless persons.include?(user)
    true
  end
  def remove_user(user, role)
    return false if not valid_role(role)
    lecture.attributes[role].delete(user)
    true
  end

  def groups
    Studentgroup.find_all{ |group| group.lecture == self }
  end
end

Lecture.maglev_record_persistable
MaglevRecord.save
Lecture.redo_include_and_extend
