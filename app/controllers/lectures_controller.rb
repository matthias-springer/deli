class LecturesController < ApplicationController
  authorize_resource

  def index
    @lectures = Lecture.all
  end

  def show
    @lecture = Lecture.find_by_objectid(params[:id])
  end

  def edit
    @lecture = Lecture.find_by_objectid(params[:id])
  end

  def update
    @lecture = Lecture.find_by_objectid(params[:id]).update_attributes(params[:lecture])

    if @lecture.valid?
      MaglevRecord.save
      redirect_to :action => :index
    else
      render "edit"
    end
  end

  def destroy
    message = {:notice => "Erfolgreich gelöscht!"}
    if Lecture.object_pool.delete(params[:id].to_i).nil?
      message = {:error => "Objekt nicht vorhanden!"}
    end
    MaglevRecord.save

    redirect_to({:action => 'index'}, message)
  end

  def join
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
    user = User.find_by_objectid(params[:user_id])
    lecture = Lecture.find_by_object_id(params[:id])
    role = params[:role].to_sym

    if user.nil? or lecture.nil?
      redirect_to add_user_list_path(lecture.id, role), :error => "Der Benutzer existiert nicht!"
    elsif not lecture.add_user(user, role)
      redirect_to add_user_list_path(lec_id, role), :error => "Der Benutzer konnte nicht eingefügt werden!"
    else
      MaglevRecord.save
      redirect_to lecture_path(lecture.id), :notice => "Vorlesung erfolgreich aktualisiert!"
    end
  end

  def remove_user
    user = User.find_by_objectid(params[:user_id])
    lecture = Lecture.find_by_objectid(params[:id])
    role = params[:role].to_sym
    
    if user.nil?
      message = { error: "der Benutzer existiert nicht!" }
    elsif not user.remove_from_lecture(lec_id, role)
      message = { error: "der Benutzer konnte nicht entfernt werden!" }
    else
      message = { notice: "Vorlesung erfolgreich aktualisiert!" }
      MaglevRecord.save
    end
    redirect_to lecture_path(lecture.id), message
  end

  def json_index
    render json: Hash[*Lecture.all.map{ |lecture| [lecture.id, lecture.title] }.flatten]
  end
end