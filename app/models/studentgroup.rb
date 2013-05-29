require "maglev_record"

class Studentgroup
  include MaglevRecord::RootedBase

  attr_accessor :students, :tutors, :name, :lecture

  validates :name, :presence => true
  validates :lecture, :presence => true

  def initialize(*args)
    super(*args)
    self.students = []
    self.tutors = []
  end

  def to_s
    "#{name}"
  end

  def add_student(user)
    return false if user.nil?
    students << user unless students.include? user
    return true
  rescue
    return false
  end

  def remove_student(user)
    return false unless students.include? user
    return false if user.nil?
    students.delete(user)
    return true
  rescue
    return false
  end

end

Studentgroup.maglev_record_persistable
Studentgroup.redo_include_and_extend
