class UsersController < ApplicationController
  authorize_resource

  before_filter :redirect_if_logged_in, only: [:new, :create]
  def redirect_if_logged_in
    @logged_in = false
    if current_user
      redirect_to root_url
      @logged_in = true
    end
  end

  def show
    @user = User.find_by_objectid(params[:id])
    render "profile" if current_user and current_user == @user
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
    return if @logged_in
    @user = User.new
  end

  def create
    return if @logged_in
    @user = User.new(params[:user])
    if @user.valid?
      @user.clear_sensibles
      MaglevRecord.save
      redirect_to root_url, :notice => "Sie haben sich erfolgreich registriert!"
    else
      render "new"
    end
  end

  def json_students
    render :json => json { |user| user.student? }
  end

  def json_tutors
    render :json => json { |user| user.tutor? }
  end

  def json(&block)
    Hash[*User.select(&block).map{ |user| [user.id, user.to_s] }.flatten]
  end

end
