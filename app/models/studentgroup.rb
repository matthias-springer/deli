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

end