class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :abort_transaction

  def abort_transaction
    MaglevRecord.reset
  end
  helper_method :current_user

  private
  def current_user
    @current_user ||= User.find_by_objectid(session[:user_id]) if session[:user_id]
  end
end
