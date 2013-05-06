require "maglev_record"

class User
  include MaglevRecord::RootedBase

  attr_accessor :first_name, :last_name, :email, :password_digest
  
  def to_s
    "#{first_name} #{last_name}"
  end

  def admin?
    @roles[:admin]
  end

  def tutor?
    @roles[:tutor]
  end

  def student?
    @roles[:student]
  end

  def initialize(*args)
    super(*args)
    
    @roles = Hash.new

    set_role(:student)
    unset_role(:admin)
    unset_role(:tutor)
  end

  def set_role(role)
    @roles[role] = true
  end

  def unset_role(role)
    @roles[role] = false
  end

  def add_to_lecture(lecture_id, as)
    lecture = Lecture.find_by_objectid(lecture_id)
    return false if lecture.nil?
    list = lecture.attributes[as]
    list << self unless list.include?(self)
    return true
  rescue
    return false
  end

  def remove_from_lecture(lecture_id, from)
    lecture = Lecture.find_by_objectid(lecture_id)
    return false if lecture.nil?
    lecture.attributes[from].delete(self)
    return true
  rescue 
    return false
  end

  def my_groups
    return Studentgroup.select do |group|
      group.students.include? self
    end
  end
end

User.maglev_record_persistable
MaglevRecord.save
class User
  include ActiveModel::Validations
  has_secure_password
  validates_presence_of :password, :on => :create

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :email, :presence => true
end
