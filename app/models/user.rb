require "maglev_record"

class User
  include MaglevRecord::RootedBase

  attr_accessor :first_name, :last_name, :email, :password_digest

  has_secure_password
  validates_presence_of :password, :on => :create

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :email, :presence => true
  
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

end
