
class StudentgroupsController < ApplicationController
  load_and_authorize_resource
  
  def index
    MaglevRecord.reset
    @groups = Studentgroup.all
  end

  def show
    @group = Studentgroup.find_by_objectid(params[:id])
  end

  def edit
    MaglevRecord.reset
    group = Studentgroup.find_by_objectid(params[:id])
    students = {}
    group.students.each{|student| students[student.id] = student.to_s}
    tutors = {}
    group.tutors.each{|tutor| tutors[tutor.id] = tutor.to_s}
    session[:group] = {
      :id => group.id, 
      :name => group.name, 
      :lecture => [group.lecture.id, group.lecture.title],
      :students => students, 
      :tutors => tutors, 
      :is_new => false}
    @link = update_studentgroup_path(group.id)
  end

  def update
    MaglevRecord.reset
    groupInfo = session[:group]
    @group = Studentgroup.find_by_objectid(groupInfo[:id])
    if @group.nil?
      redirect_to studentgroups_path, {:error => "Die Gruppe existiert nicht!"}
      return
    end
    @group.name = params[:studentgroup_name]
    lecture = Lecture.find_by_objectid(params[:chosen_lecture])
    if lecture.nil?
      redirect_to studentgroups_path, {:error => "Die Vorlesung existiert nicht!"}
      return
    end
    @group.lecture = lecture
    @group.students = User.select{ |user| groupInfo[:students].include? user.id }
    @group.tutors = User.select{ |user| groupInfo[:tutors].include? user.id }
    if @group.valid?
      MaglevRecord.save
      redirect_to studentgroups_path
      session.delete(:group)
    else
      render "edit"
    end
  end

  def destroy
    MaglevRecord.reset
    message = {:notice => "Erfolgreich gelöscht!"}
    if Studentgroup.object_pool.delete(params[:id].to_i).nil?
      message = {:error => "Objekt nicht vorhanden!"}
    end
    MaglevRecord.save

    redirect_to studentgroups_path, message

  end

  def new
    MaglevRecord.reset
    session[:group] = {
      :name => "",
      :lecture => [nil, ""],
      :students => {current_user.id => current_user.to_s},
      :tutors => {},
      :is_new => true
    }
    @link = update_new_studentgroup_path
  end

  def update_from_session
    student_id = params[:chosen_student]
    tutor_id = params[:chosen_tutor]

    student_to_delete = params[:student_to_delete]
    tutor_to_delete = params[:tutor_to_delete]

    session[:group][:name] = params[:studentgroup_name]


    message = {}
    if student_to_delete.empty? and tutor_to_delete.empty?
      message = _update_messages(_add_user(student_id, :students), message) unless student_id.empty?
      message = _update_messages(_add_user(tutor_id, :tutors), message) unless tutor_id.empty?
    else
      message = _update_messages(_remove_user(student_to_delete, :students), message) unless student_to_delete.empty?
      message = _update_messages(_remove_user(tutor_to_delete, :tutors), message) unless tutor_to_delete.empty?
    end
        
    lecture_id = params[:chosen_lecture]
    lecture = Lecture.find_by_objectid(lecture_id)

    session[:group][:lecture] = [lecture.id, lecture.title] unless lecture.nil?

    if session[:group][:is_new]
      render "new", message
    else
      render "edit", message
    end
  end

  def _update_messages(mes_str_arr, message)

    new_notice = mes_str_arr[0]
    new_error = mes_str_arr[1]

    notice = (message[:notice] or "")
    error = (message[:error] or "")

    error += new_error unless new_error.nil?

    notice += new_notice unless new_notice.nil?

    return {:error => error, :notice => notice}
  end

  def _add_user(user_id, dict_sym)
    user = User.find_by_objectid(user_id)

    if user.nil?
      return [nil, "Benutzer existiert nicht!"]
    end

    user_dict = session[:group][dict_sym]
    unless user_dict.include? user.id
      user_dict[user.id] = user.to_s
      session[:group][dict_sym].update(user_dict)
      return ["Benutzer #{user.to_s} erfolgreich eingefügt!", nil]
    else
      return [nil, nil]
    end
  end

  def _remove_user(user_id, dict_sym)
    user = session[:group][dict_sym].delete(user_id.to_i)
    puts user
    if user.nil?
      return [nil, "Benutzer existiert nicht!"]
    else
      return ["Benutzer #{user} erfolgreich aus der Gruppe entfernt!", nil]
    end
  end

  def create
    MaglevRecord.reset
    groupInfo = session[:group]
    students = User.select{ |user| groupInfo[:students].include? user.id }
    tutors = User.select{ |user| groupInfo[:tutors].include? user.id }
    name = params[:studentgroup_name]

    @group = Studentgroup.new(:name => name)

    lecture = Lecture.find_by_objectid(params[:chosen_lecture])
    if lecture.nil?
      render "new", {:error => "Die Vorlesung existiert nicht!"}
      return
    end
    @group.lecture = lecture
    @group.students = students
    @group.tutors = tutors 

    if @group.valid?
      MaglevRecord.save
      redirect_to studentgroups_path
      session.delete(:group)
    else 
      render "new"
    end
  end

end