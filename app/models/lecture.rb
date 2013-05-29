require "maglev_record"

class Lecture
  include MaglevRecord::RootedBase

  attr_accessor :title, :lecturer, :description, :groups, :students, :tutors, :staff

  validates :title, :presence => true
  validates :description, :presence => true

  def to_s
    "#{title}, #{description}"
  end

  def initialize(*args)
    super(*args)
    self.groups = []
    self.students = []
    self.tutors = []
    self.staff = []
  end
end

Lecture.maglev_record_persistable
