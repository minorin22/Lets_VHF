class Admin::StationsController < ApplicationController
  before_action :admin_station



  def edit
    @station = Station.find(params[:id])
  end

  def update
    @station = Station.find_by(id: params[:id])
    @station.name = params[:name].upcase
    @station.call_sign = params[:call_sign].upcase
    @station.region = params[:region]
    if @station.region == "tokyo"
      @station.lat = rand(35.444...35.619)
      @station.long = rand(139.792...140.222)
    elsif @station.region == "osaka"
      @station.lat = rand(34.392...34.635)
      @station.long = rand(135.035...135.314)
    end
    if @station.save
      redirect_to("/admin")
      flash[:notice] = "局情報を更新しました"
    else
      @error_message = "*"
      @name = params[:name]
      render("admin/stations/edit")
    end
  end
  private
  def admin_station
    redirect_to("/") unless @current_user.admin?
  end
end
