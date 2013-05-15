module DeliControllerTestCase

  def login_student
    @user = User.new({first_name: "First", last_name:"Last"})
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

end