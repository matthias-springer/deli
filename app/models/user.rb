require "maglev_record"

class User
  include MaglevRecord::RootedBase

  attr_accessor :first_name, :last_name, :email, :password_digest

  has_secure_password
  validates_presence_of :password, :on => :create

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :email, :presence => true
  
end
