require 'maglev_record'
class LecturesController < ApplicationController
  
  def index
    @lectures = Lecture.all
  end

  def show
    redirect_to :action => :index
  end

  def edit
    @lecture = Lecture.find_by_objectid(params[:id])
  end

  def update
    @lecture.update_attributes(params[:lecture])
    redirect_to :action => :index
  end

  def destroy
    redirect_to :action => :index
  end

  def new
    @lecture = Lecture.new

    # respond_to do |format|
    #   format.html
    #   format.json { render json: @lecture }
    # end
  end

  def create
    MaglevRecord.reset

    @lecture = Lecture.new(params[:lecture]) #

    MaglevRecord.save

    redirect_to :action => :index
  end

end