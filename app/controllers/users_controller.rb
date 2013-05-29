class UsersController < ApplicationController
  load_and_authorize_resource
  
  def index

  end

  def show
    redirect_to :action => :index
  end

  def edit
    redirect_to :action => :index

  end

  def update
    redirect_to :action => :index

  end

  def destroy
    redirect_to :action => :index

  end

  def new
    redirect_to root_url if current_user
    
    @user = User.new
  end

  def create
    redirect_to root_url if current_user

    MaglevRecord.reset

    @user = User.new(params[:user])
    if @user.valid?
      @user.clear_sensibles
      MaglevRecord.save
      redirect_to root_url, :notice => "Sie haben sich erfolgreich registriert!"
    else
      render "new"
    end

  end
end
