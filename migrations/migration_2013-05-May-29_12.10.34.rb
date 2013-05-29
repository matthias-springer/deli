require "maglev_record/migration"
require "time"

MaglevRecord::Migration.new(Time.parse('Wed May 29 12:10:34 +0000 2013'), 'fill in description here') do

  def up
    #new class: Lecture
    #new class: StudentGroup
    #new class: User
  end

  def down
    delete_class Lecture
    delete_class StudentGroup
    delete_class User
  end

end
