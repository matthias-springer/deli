class UsersController < ApplicationController
  load_and_authorize_resource
  
  def show
    MaglevRecord.reset
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


  def join_group_list
    raise "wrong url!" unless params[:id].to_i == current_user.id
    @groups = Studentgroup.select do |group|
      not group.students.include? current_user
    end

  end

  def join_group
    myId = params[:id].to_i
    raise "wrong url!" unless myId == current_user.id
    MaglevRecord.reset
    group = Studentgroup.find_by_objectid(params[:group_id])
    message = nil
    if group.nil?
      message = {:error => "Die Gruppe existiert nicht!"}
    end

    if !group.add_student(User.find_by_objectid(myId)) and message.nil?
      message = {:error => "Du kannst in diese Gruppe nicht beitreten!"}
    end
    
    if message.nil?
      MaglevRecord.save
      message = {:notice => "Du hast die Gruppe #{group.to_s} erfolgreich beigetreten!"}
    end

    redirect_to user_path(myId), message
  end

  def leave_group
    myId = params[:id].to_i
    raise "wrong url!" unless myId == current_user.id
    
    MaglevRecord.reset
    group = Studentgroup.find_by_objectid(params[:group_id])
    message = nil
    if group.nil?
      message = {:error => "Die Gruppe existiert nicht!"}
    end

    if !group.remove_student(User.find_by_objectid(myId)) and message.nil?
      message = {:error => "Du bist nicht in dieser Gruppe eingetragen!"}
    end
    
    if message.nil?
      MaglevRecord.save
      message = {:notice => "Du hast erfolgreich die Gruppe #{group.to_s} verlassen!"}
    end

    redirect_to user_path(myId), message
  end

end
