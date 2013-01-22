require "maglev_record"

class Lecture
  include MaglevRecord::Base

  attr_accessible :title, :lecturer, :lecture_description, :groups, :students, :tutors, :staff
  attr_accessor :title, :lecturer, :lecture_description, :groups, :students, :tutors, :staff

  validates :title, :presence => true
  validates :lecturer, :presence => true
end
