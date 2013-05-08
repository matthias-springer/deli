
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

  def update_new
    student_id = params[:chosen_student]
    tutor_id = params[:chosen_tutor]

    session[:group][:name] = params[:studentgroup_name]

    message = {}
    message = _update_messages(_add_user(student_id, :students), message) unless student_id.empty?
    message = _update_messages(_add_user(tutor_id, :tutors), message) unless tutor_id.empty?
        
    render "new", message
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

  def create
    groupInfo = session[:group]
    students = User.select{ |user| groupInfo[:students].include? user.id }
    tutors = User.select{ |user| groupInfo[:tutors].include? user.id }
    name = params[:studentgroup_name]
    @group = Studentgroup.new(:name => name)

    @group.students = students
    @group.tutors = tutors 
    
    MaglevRecord.save
    redirect_to user_path(current_user.id)
    session.delete(:group)
  end

end