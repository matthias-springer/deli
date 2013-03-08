require "maglev_record"

puts "====> Loading Lecture"
Maglev.persistent do
  class Lecture
    include MaglevRecord::RootedBase

    # attr_accessible :title, :lecturer, :description, :groups, :students, :tutors, :staff
    attr_accessor :title, :lecturer, :description, :groups, :students, :tutors, :staff

    # validates :title, :presence => true
    # validates :description, :presence => true

    def to_s
      "#{title}, #{description}"
    end
  end
end
