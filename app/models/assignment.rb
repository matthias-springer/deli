require "maglev_record"

class Assignment
  include MaglevRecord::Base

  attr_accessor :title, :soft_date, :hard_date, :status, :parts

  validates :title, :soft_date, :hard_date, :presence => true
end

Assignment.maglev_record_persistable
MaglevRecord.save
Assignment.redo_include_and_extend
