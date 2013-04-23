require "maglev_record"

class User
  include MaglevRecord::RootedBase

  attr_accessor :first_name, :last_name, :email, :password

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :email, :presence => true
  validates :password, :presence => true
  
end