require "maglev_record"

class User
  include MaglevRecord::RootedBase

  attr_accessor :first_name, :last_name, :email, :password_digest, :password_confirmation
  
  has_secure_password
  validates_presence_of :password, :on => :create

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :email, :presence => true

  def full_name
    "#{first_name} #{last_name}"
  end

  def to_s
    full_name
  end

  def admin?
    @roles[:admin]
  end
  def admin!
    set_role(:admin)
  end
  def no_admin!
    unset_role(:admin)
  end
  def tutor?
    @roles[:tutor]
  end
  def tutor!
    set_role(:tutor)
  end
  def no_tutor!
    unset_role(:tutor)
  end
  def student?
    @roles[:student]
  end
  def student!
    set_role(:student)
  end
  def no_student!
    unset_role(:tutor)
  end

  def initialize(*args)
    super(*args)
    @roles = Hash.new
    student!
    no_admin!
    no_tutor!
  end

  def set_role(role)
    @roles[role] = true
  end
  def unset_role(role)
    @roles[role] = false
  end
  protected :set_role, :unset_role


  def my_groups
    return Studentgroup.select do |group|
      group.students.include? self
    end
  end

  def my_lectures
    return Lecture.select do |lecture|
      lecture.students.include? self
    end
  end

  def in_lecture?(lecture_id)
    lecture = Lecture.find_by_objectid(lecture_id)
    if lecture
      return lecture.students.include? self
    else
      return false
    end
  end

  def in_group?(group_id)
    group = Studentgroup.find_by_objectid(group_id)
    if group
      return group.students.include? self
    else
      return false
    end
  end

end

User.maglev_record_persistable
MaglevRecord.save
User.redo_include_and_extend
