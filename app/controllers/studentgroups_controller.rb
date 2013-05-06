
class StudentgroupsController < ApplicationController
  load_and_authorize_resource
  
  def index
  end

  def show
    @group = Studentgroup.find_by_objectid(params[:id])
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def new
    MaglevRecord.reset
    @group = Studentgroup.new

    @group.students << current_user
  end

  def add_student
    @group = Studentgroup.find_by_objectid(params[:id])
    user = User.find_by_objectid(params[:chosen_student])
    if user.nil?
      message = {:error => "Dieser Benutzer esistiert nicht!"}
    elsif not @group.students.include? user
      @group.students << user
      MaglevRecord.save
      message = {:notice => "Benutzer erfolgreich eingefügt!"}
    end
    render "new", message
  end

  def add_tutor
    @group = Studentgroup.find_by_objectid(params[:id])
    user = User.find_by_objectid(params[:chosen_tutor])
    if user.nil?
      message = {:error => "Dieser Benutzer esistiert nicht!"}
    elsif not @group.tutors.include? user
      @group.tutors << user
      MaglevRecord.save
      message = {:notice => "Tutor erfolgreich eingefügt!"}
    end
    render "new", message
  end

  def create
    puts "X"*100
    puts params
    @group = Studentgroup.find_by_objectid(params[:studentgroup][:id])
    if @group.valid?

      MaglevRecord.save
      redirect_to user_path(current_user.id)
    else      
      render "new", {:error => "Die Gruppe konnte nicht erstellt werden"}
    end
  end

end