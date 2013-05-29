class AssignmentsController < ApplicationController
  authorize_resource

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def new
    @lecture = Lecture.find_by_objectid(params[:lecture_id])
    @assignment = Assignment.new lecture: @lecture
  end

  def create
  end
end