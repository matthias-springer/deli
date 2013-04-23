
class LecturesController < ApplicationController
  
  def index
    MaglevRecord.reset
    @lectures = Lecture.all
  end

  def show
    redirect_to :action => :index
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
    redirect_to :action => :index
  end

  def new
    @lecture = Lecture.new
  end

  def create

    MaglevRecord.reset

    @lecture = Lecture.new(params[:lecture]) #

    if @lecture.valid?
      MaglevRecord.save
      redirect_to :action => :index
    else
      render "new"
    end


  end

end