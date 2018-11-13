class ApplicationController < ActionController::Base
  before_action :set_current_user
  protect_from_forgery
  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
    if @current_user
      @current_station = Station.find_by(user_id: @current_user.id)
    end
  end

  def authenticate_user
    if @current_user == nil
      flash[:notice] = "ログインが必要です"
      redirect_to("/login")
    end
  end

  def forbid_login_user
    if @current_user
      flash[:notice] = "すでにログインしています"
      redirect_to("/users/#{@current_user.id}")
    end
  end

  def authenticate_station
    if @current_station == nil
      flash[:notice] = "局情報の登録が必要です"
      redirect_to("/stations/new")
    end
  end

  def forbid_login_station
    if @current_station
      flash[:notice] = "すでに登録しています"
      redirect_to("/stations/#{@current_station.id}")
    end
  end
end
