
class LecturesController < ApplicationController
  
  def index
    @lectures = Lecture.all
  end

  def show
    redirect_to :action => :index
  end

  def edit
    # first get possible errors
    @errors = flash[:errors]

    # then reset, to get the newest content
    MaglevRecord.reset
    @lecture = Lecture.find_by_objectid(params[:id])
  end

  def update
    MaglevRecord.reset
    obj = Lecture.find_by_objectid(params[:id]).update_attributes(params[:lecture])

    if obj.valid?
      MaglevRecord.save
      redirect_to :action => :index
    else
      flash[:errors] = obj.errors.full_messages
      redirect_to :action => :edit
    end
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