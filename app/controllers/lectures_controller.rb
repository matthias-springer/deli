require 'maglev_record'
class LecturesController < ApplicationController
  
  def index
    # render index
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
    Maglev.persistent do
      @lecture = Lecture.new(params[:lecture])
    end

    puts "PTINT!!!!!!!!!!!!!!!!! #{@lecture}"
    
    if @lecture.valid?
      MaglevRecord.save
    end

  end

end