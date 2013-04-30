
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
      message = {:alert => "Objekt nicht vorhanden!"}
    end
    MaglevRecord.save

    redirect_to({:action => 'index'}, message)
  end


  def new
    @lecture = Lecture.new
  end

  def create

    MaglevRecord.reset

    @lecture = Lecture.new(params[:lecture]) #

    if @lecture.valid?
      MaglevRecord.save
      flash[:message] = "Vorlesung erfolgreich erstellt!"
      redirect_to :action => :index
    else
      render "new"
    end


  end

end