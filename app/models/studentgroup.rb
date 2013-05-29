require "maglev_record"

class Studentgroup
  include MaglevRecord::RootedBase

  attr_accessor :name, :creator
  attr_accessor :students, :tutors, :lecture

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
    return false if user.nil? or students.include? user
    students << user
    true
  end

  def remove_student(user)
    return false unless students.include? user
    return false if user.nil?
    students.delete(user)
    true
  end

end

Studentgroup.maglev_record_persistable
Studentgroup.redo_include_and_extend
