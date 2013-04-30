
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
  end

  def create
  end

end