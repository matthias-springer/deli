require "maglev_record"

class Studentgroup
  include MaglevRecord::RootedBase

  attr_accessor :students, :tutors
  
  def initialize(*args)
    super(*args)
    self.students = []
    self.tutors = []
  end

  def to_s
    "##{object_id}"
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