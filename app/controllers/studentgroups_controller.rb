class StudentgroupsController < ApplicationController
  authorize_resource

  before_filter :get_resources, only: [:show, :edit, :update, :destroy, :join]

  def get_resources
    @group = Studentgroup.find_by_objectid(params[:id])
    if @group.nil?
      redirect_to studentgroups_path, flash: { error: "Diese Gruppe existiert nicht!" }
    end
  end

  def index
    @groups = Studentgroup.all
  end

  def show
  end

  def edit
    students = Hash[@group.students.map { |student| [student.id, student.to_s] }]
    tutors = Hash[@group.tutors.map { |tutor| [tutor.id, tutor.to_s] }]
    session[:group] = {
      id: @group.id,
      name: @group.name,
      lecture: { id: @group.lecture.id, title: @group.lecture.title },
      students: students,
      tutors: tutors,
      is_new: false }
  end

  def build_group_attributes
    group_info = session[:group]
    {
      name: params[:studentgroup_name],
      creator: current_user,
      lecture: Lecture.find_by_objectid(params[:chosen_lecture]),
      students: group_info[:students].keys.map { |id| User.find_by_objectid(id) },
      tutors: group_info[:tutors].keys.map { |id| User.find_by_objectid(id) }

    }
  end
  def update
    group_attributes = build_group_attributes
    @group.update_attributes(group_attributes)
    if @group.valid?
      session.delete(:group)
      redirect_to studentgroups_path
      MaglevRecord.save
    else
      render "edit"
    end
  end

  def destroy
    @group.destroy
    redirect_to studentgroups_path, notice: "Gruppe erfolgreich gelöscht!"
    MaglevRecord.save
  end

  def new
    session[:group] = {
      name: "",
      lecture: { title: "" },
      students: {current_user.id => current_user.to_s},
      tutors: {},
      is_new: true
    }
  end

  def create
    group_attributes = build_group_attributes
    @group = Studentgroup.new(group_attributes)
    if @group.valid?
      session.delete(:group)
      redirect_to studentgroups_path
      MaglevRecord.save
    else
      render "new"
    end
  end

  def join
    if @group.add_student(current_user)
      redirect_to studentgroups_path, notice: "Du bist erfolgreich der Gruppe #{@group.to_s} beigetreten!"
      MaglevRecord.save
    else
      redirect_to studentgroups_path, notice: "Du bist bereits in dieser Gruppe!"
    end
  end

  def list_for_join
    @groups = Studentgroup.find_all { |group| not group.students.include?(current_user)}
  end

  def leave
    group = Studentgroup.find_by_objectid(params[:id])
    if group.students.delete(current_user).nil?
      redirect_to studentgroups_path
    else
      MaglevRecord.save
      redirect_to studentgroups_path, :notice => "Du hast erfolgreich die Gruppe #{group.to_s} verlassen!"
    end
  end

  def edit_temp
    send edit_temp_action

    session[:group][:name] = params[:studentgroup_name]

    lecture_id = params[:chosen_lecture]
    lecture = Lecture.find_by_objectid(lecture_id)

    if lecture.nil?
      flash[:error] = "Bitte eine Vorlesung auswählen!"
    else
      session[:group][:lecture] = { id: lecture.id, title: lecture.title }
    end

    if session[:group][:is_new]
      render "new"
    else
      render "edit"
    end
  end

  protected
  def edit_temp_action
    action = [:add_student, :add_tutor, :delete_student, :delete_tutor].detect {|action| params[action] }
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

  def edit_temp_do(role, action)
    user_id = params["#{role}_to_#{action}".to_sym]
    unless user_id.empty?
      yield(user_id) if block_given?
    end
  end

  def edit_temp_add(role)
    edit_temp_do(role, "add") do |user_id|
      _add_user(user_id, "#{role}s".to_sym)
    end
  end
  def edit_temp_delete(role)
    edit_temp_do(role, "delete") do |user_id|
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
    user = user_dict.delete(user_id.to_i)
    if user.nil?
      flash[:error] = "Benutzer existiert nicht!"
    else
      flash[:notice] = "Benutzer #{user.to_s} erfolgreich aus der Gruppe entfernt!"
    end
  end
end