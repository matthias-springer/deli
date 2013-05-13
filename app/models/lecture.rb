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

  def groups
    Studentgroup.find_all{ |group| group.lecture == self }
  end
end

Lecture.maglev_record_persistable
MaglevRecord.save
Lecture.redo_include_and_extend
