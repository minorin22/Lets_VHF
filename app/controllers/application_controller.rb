class ApplicationController < ActionController::Base
  before_action :set_current_user
  protect_from_forgery
  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
    if @current_user
      @current_station = Station.find_by(user_id: @current_user.id)
    end
  end
end
