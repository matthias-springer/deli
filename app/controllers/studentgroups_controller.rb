
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
    session[:group] = {
      :name => "",
      :students => {current_user.id => current_user.to_s},
      :tutors => {}
    }
  end

  def add_student
    user = User.find_by_objectid(params[:chosen_student])
    puts params
    if user.nil?
      render "new", {:error => "Dieser Benutzer esistiert nicht!"}
      return
    end
    students = session[:group][:students]
    unless students.include? user.id
      students[user.id] = user.to_s
      session[:group][:students].update(students)
      render "new", {:error => "Student erfolgreich eingefügt!"}
    else
      render "new"
    end
  end

  def add_tutor
    user = User.find_by_objectid(params[:chosen_tutor])
    if user.nil?
      render "new", {:error => "Dieser Benutzer esistiert nicht!"}
      return
    end
    tutors = session[:group][:tutors]
    unless tutors.include? user.id
      tutors[user.id] = user.to_s
      session[:group][:tutors].update(tutors)
      render "new", {:error => "Tutor erfolgreich eingefügt!"}
    else
      render "new"
    end
  end

  def create
    groupInfo = session[:group]
    students = User.select{ |user| groupInfo[:students].include? user.id }
    tutors = User.select{ |user| groupInfo[:tutors].include? user.id }
    
    @group = Studentgroup.new(:name => "Gruppe1")

    @group.students = students or []
    @group.tutors = tutors or []
    
    MaglevRecord.save
    redirect_to user_path(current_user.id)
  end

end