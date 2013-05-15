
class StudentgroupsController < ApplicationController
  authorize_resource

  def index
    @groups = Studentgroup.all
  end

  def show
    @group = Studentgroup.find_by_objectid(params[:id])
  end

  def edit
    group = Studentgroup.find_by_objectid(params[:id])
    students = {}
    group.students.each{|student| students[student.id] = student.to_s}
    tutors = {}
    group.tutors.each{|tutor| tutors[tutor.id] = tutor.to_s}
    session[:group] = {
      id: group.id,
      name: group.name,
      lecture: [group.lecture.id, group.lecture.title],
      students: students,
      tutors: tutors,
      is_new: false}
    @link = edit_temp_path(group.id)
  end

  def update
    groupInfo = session[:group]
    @group = Studentgroup.find_by_objectid(groupInfo[:id])
    if @group.nil?
      flash[:error] = "Die Gruppe existiert nicht!"
      redirect_to studentgroups_path
      return
    end
    @group.name = params[:studentgroup_name]
    lecture = Lecture.find_by_objectid(params[:chosen_lecture])
    if lecture.nil?
      flash[:error] = "Die Vorlesung existiert nicht!"
      redirect_to studentgroups_path
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
    if Studentgroup.object_pool.delete(params[:id].to_i).nil?
      flash[:error] = "Gruppe ist nicht vorhanden!"
    else
      flash[:notice] = "Gruppe erfolgreich gelöscht!"
    end
    MaglevRecord.save

    redirect_to studentgroups_path

  end

  def new
    session[:group] = {
      name: "",
      lecture: [nil, ""],
      students: {current_user.id => current_user.to_s},
      tutors: {},
      is_new: true
    }
    @link = edit_new_temp_path
  end

  def create
    groupInfo = session[:group]
    students = User.select{ |user| groupInfo[:students].include? user.id }
    tutors = User.select{ |user| groupInfo[:tutors].include? user.id }
    name = params[:studentgroup_name]

    @group = Studentgroup.new name: name

    lecture = Lecture.find_by_objectid(params[:chosen_lecture])
    if lecture.nil?
      flash[:error] = "Die Vorlesung existiert nicht!"
      render "new"
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

  # your form action
  def edit_temp
    send edit_temp_action

    session[:group][:name] = params[:studentgroup_name]

    lecture_id = params[:chosen_lecture]
    lecture = Lecture.find_by_objectid(lecture_id)

    if lecture.nil?
      flash[:error] = "Bitte eine Vorlesung auswählen!"
    else
      session[:group][:lecture] = [lecture.id, lecture.title]
    end

    if session[:group][:is_new]
      render "new"
    else
      render "edit"
    end
  end

  protected
  def edit_temp_action
    # just return the first action name found in the params
    action = %w(add_student add_tutor delete_student delete_tutor).detect {|action| params[action] }
    "edit_temp_#{action}"
  end

  def edit_temp_add_student
    edit_temp_add("student")
  end

  def edit_temp_delete_student
    edit_temp_delete("student")
  end

  def edit_temp_add_tutor
    edit_temp_add("tutor")
  end

  def edit_temp_delete_tutor
    edit_temp_delete("tutor")
  end



  def edit_temp_add(role)
    user_id = params["#{role}_to_add".to_sym]
    unless user_id.empty?
      _add_user(user_id, "#{role}s".to_sym)
    end
  end

  def edit_temp_delete(role)
    user_id = params["#{role}_to_delete".to_sym]
    unless user_id.empty?
      _delete_user(user_id, "#{role}s".to_sym)
    end
  end


  def _add_user(user_id, dict_sym)
    user = User.find_by_objectid(user_id)

    if user.nil?
      flash[:error] = "Benutzer existiert nicht!"
    else
      user_dict = session[:group][dict_sym]
      unless user_dict.include? user.id
        user_dict[user.id] = user.to_s
        session[:group][dict_sym].update(user_dict)
        flash[:notice] = "Benutzer #{user.to_s} erfolgreich eingefügt!"
      end
    end
  end

  def _delete_user(user_id, dict_sym)
    user_dict = session[:group][dict_sym]
    nil.pause if user_dict.nil?
    user = user_dict.delete(user_id.to_i)
    if user.nil?
      flash[:error] = "Benutzer existiert nicht!"
    else
      flash[:notice] = "Benutzer #{user.to_s} erfolgreich aus der Gruppe entfernt!"
    end
  end


end