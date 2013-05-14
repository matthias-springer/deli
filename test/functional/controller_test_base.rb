module DeliControllerTestCase

  def login_student
    @user = User.new
    session[:user_id] = @user.id
    MaglevRecord.save
  end
  def login_admin
    @user.set_role(:admin)
    MaglevRecord.save
  end

  def logout
    session[:user_id] = nil
  end

  def setup
    login_student
  end
  def teardown
    User.clear
    MaglevRecord.save
  end
end