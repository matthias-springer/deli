class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user
    if user.nil?
      guest
    elsif user.admin?
      admin
    else
      student
    end

  end

  def guest
    can :create, User
  end

  def admin
    can :manage, :all
  end

  def student
    guest
    can :show, User do |user| user == @user end
    can :read, Lecture
    can :join, Lecture
    can :leave, Lecture
    can :create, Studentgroup
  end

  def tutor
    guest
    student
  end

end
