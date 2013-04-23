class UsersController < ApplicationController

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
    # first get possible errors
    @user = User.new
  end

  def create

    MaglevRecord.reset

    @user = User.new(params[:user])
    if @user.valid?
      MaglevRecord.save
      redirect_to :action => :index
    else
      render "new"
    end

  end
end
