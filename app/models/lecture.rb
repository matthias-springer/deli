require "maglev_record"

class Lecture
  include MaglevRecord::RootedBase

  attr_accessor :title, :lecturer, :description, :groups, :students, :tutors, :staff

  def to_s
    "#{title}, #{description}"
  end

  def initialize(*args)
    super(*args)
    self.lecturer = []
    self.groups = []
    self.students = []
    self.tutors = []
    self.staff = []
  end
end

Lecture.maglev_record_persistable
MaglevRecord.save
class Lecture
  include ActiveModel::Validations

  validates :title, :presence => true
  validates :description, :presence => true
end

Lecture.redo_include_and_extend
