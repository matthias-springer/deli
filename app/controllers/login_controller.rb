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
    puts "Handle signup with #{params}!"
  
    @user = User.new(params[:user])
    Maglev.save if user.valid?
  end

end
