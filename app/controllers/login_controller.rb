class LoginController < ApplicationController
  
  def index
    # render input form
  end

  def handle_login
    puts "Handle login with #{params}!"
  end

  def singup
    # render singup form
  end

  def handle_signup
    MaglevRecord.reset
   
    Maglev.persistent do
      @user = User.new(params[:user])
    end
   
    MaglevRecord.save #if @user.valid?
   
  end

end
