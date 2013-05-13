
class LecturesController < ApplicationController
  load_and_authorize_resource

  def index
    MaglevRecord.reset
    @lectures = Lecture.all
  end

  def show
    MaglevRecord.reset
    @lecture = Lecture.find_by_objectid(params[:id])
  end

  def edit
    MaglevRecord.reset
    @lecture = Lecture.find_by_objectid(params[:id])
  end

  def update
    MaglevRecord.reset
    @lecture = Lecture.find_by_objectid(params[:id]).update_attributes(params[:lecture])

    if @lecture.valid?
      MaglevRecord.save
      redirect_to :action => :index
    else
      render "edit"
    end
  end

  def destroy
    MaglevRecord.reset
    message = {:notice => "Erfolgreich gelöscht!"}
    if Lecture.object_pool.delete(params[:id].to_i).nil?
      message = {:error => "Objekt nicht vorhanden!"}
    end
    MaglevRecord.save

    redirect_to({:action => 'index'}, message)
  end

  def join
    MaglevRecord.reset
    lec = Lecture.find_by_objectid(params[:id])
    if lec
      lec.students << current_user unless lec.students.include? current_user
      MaglevRecord.save
      redirect_to :back, :notice => "Du hast dich erfolgreich in einer Vorlesung angemeldet!"
    else
      redirect_to :back, :error => "Diese Vorlesung existiert nicht!" 
    end
  end

  def leave
    MaglevRecord.reset
    lec = Lecture.find_by_objectid(params[:id])
    if lec
      lec.students.delete(current_user) if lec.students.include? current_user
      MaglevRecord.save
      redirect_to :back, :notice => "Du hast dich erfolgreich aus der Vorlesung abgemeldet!"
    else
      redirect_to :back, :error => "Diese Vorlesung existiert nicht!" 
    end
  end

  def new
    @lecture = Lecture.new
  end

  def create
    MaglevRecord.reset
    @lecture = Lecture.new(params[:lecture])
    if @lecture.valid?
      MaglevRecord.save
      flash[:message] = "Vorlesung erfolgreich erstellt!"
      redirect_to :action => :index
    else
      render "new"
    end
  end

  def add_user_list
    @users = User.all
    render 'add_user_list'
  end

  def add_user
    MaglevRecord.reset
    user = User.find_by_objectid(params[:user_id])
    lec_id = params[:id]
    role = params[:role].to_sym
    if not valid_role(role)
      raise Error, "invalid url!"
    end
    if user.nil?
      redirect_to add_user_list_path(lec_id, role), :error => "der Benutzer existiert nicht!"
      return
    end
    if not user.add_to_lecture(lec_id, role)
      redirect_to add_user_list_path(lec_id, role), :error => "der Benutzer konnte nicht eingefügt werden!"
      return
    end
    MaglevRecord.save
    redirect_to lecture_path(lec_id), :notice => "Vorlesung erfolgreich aktuallisiert!"
  end

  def remove_user
    MaglevRecord.reset
    user = User.find_by_objectid(params[:user_id])
    lec_id = params[:id]
    role = params[:role].to_sym
    if not valid_role(role)
      raise Error, "invalid url!"
    end
    message = nil
    
    if user.nil?
      message = {:error => "der Benutzer existiert nicht!"}
    end
    if not user.remove_from_lecture(lec_id, role) and message.nil?
      message = {:error => "der Benutzer konnte nicht entfernt werden!"}
    end
    
    if message.nil?
      MaglevRecord.save
      message = {:notice => "Vorlesung erfolgreich aktuallisiert!"} 
    end
    redirect_to lecture_path(lec_id), message
  end

  def json_index
    render :json => Hash[*Lecture.all.map{ |lecture| [lecture.id, lecture.title] }.flatten]
  end
  
  private

  def valid_role(role)
    return [:tutors, :lecturer, :staff].include?(role.to_sym)
  end


end