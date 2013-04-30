class SessionsController < ApplicationController
  def new
    redirect_to root_url if current_user
  end

  def create
    redirect_to root_url if current_user

    user = User.detect {|user| user.email == params[:email]}
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_url, :notice => "Logged in!"
    else
      flash.now[:error] = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    if not current_user
      redirect_to root_url 
      return
    end
    
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
end