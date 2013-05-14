class LecturesController < ApplicationController
  authorize_resource

  before_filter :get_resources, only: [:show, :edit, :update, :join, :leave, :add_user, :remove_user]

  def get_resources
    @lecture = Lecture.find_by_objectid(params[:id])
    if @lecture.nil?
      redirect_to lectures_path, notice: "Diese Vorlesung existiert nicht!"
    end
  end

  def index
    @lectures = Lecture.all
  end

  def show
  end

  def edit
  end

  def update
    @lecture.update_attributes(params[:lecture])

    if @lecture.valid?
      MaglevRecord.save
      redirect_to :action => :index
    else
      render "edit"
    end
  end

  def destroy
    if Lecture.object_pool.delete(params[:id].to_i).nil?
      redirect_to action: 'index' , notice: "Objekt nicht vorhanden!"
    else
      redirect_to action: 'index' , notice: "Erfolgreich gelöscht!"
      MaglevRecord.save
    end
  end

  def join
    @lecture.students << current_user unless @lecture.students.include? current_user
    redirect_to :back, :notice => "Du hast dich erfolgreich in der Vorlesung angemeldet!"
    MaglevRecord.save
  end

  def leave
    @lecture.students.delete(current_user)
    redirect_to :back, :notice => "Du hast dich erfolgreich aus der Vorlesung abgemeldet!"
    MaglevRecord.save
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
    role = params[:role].to_sym

    if user.nil?
      redirect_to add_user_list_path(@lecture.id, role), error: "Der Benutzer existiert nicht!"
    elsif not @lecture.add_user(user, role)
      redirect_to add_user_list_path(@lecture, role), error: "Der Benutzer konnte nicht eingefügt werden!"
    else
      MaglevRecord.save
      redirect_to lecture_path(@lecture.id), notice: "Vorlesung erfolgreich aktualisiert!"
    end
  end

  def remove_user
    user = User.find_by_objectid(params[:user_id])
    role = params[:role].to_sym
    
    if user.nil?
      message = { error: "Der Benutzer existiert nicht!" }
    elsif not @lecture.remove_user(user, role)
      message = { error: "Der Benutzer konnte nicht entfernt werden!" }
    else
      message = { notice: "Vorlesung erfolgreich aktualisiert!" }
      MaglevRecord.save
    end
    redirect_to lecture_path(@lecture.id), message
  end

  def json_index
    render json: Hash[*Lecture.all.map{ |lecture| [lecture.id, lecture.title] }.flatten]
  end
end