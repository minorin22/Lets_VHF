class StationsController < ApplicationController
  def index
  end

  def show
    @station = Station.find_by(id: params[:id])
  end

  def new
    @station = Station.new
  end

  def edit
  end

  def create
    @station = Station.new(
      user_id: @current_user.id,
      name: params[:name],
      call_sign: params[:call_sign],
      mmsi: 431000000 + @current_user.id.to_i,
      lat: 34.333,
      long: 154.53,
      region: params[:region],
      channel: 16
    )
    if @station.save
      redirect_to("/stations/#{@station.id}")
      #flash[:notice] = "局情報を登録しました！ Ship's Name : #{@station.name}  Call Sign : #{@station.call_sign}  MMSI : #{@station.mmsi}"
    else
      @error_message = "*"
      @name = params[:name]
      @call_sign = params[:call_sign]
      render("stations/new")
    end
  end

  def update
  end

  def destroy
  end

end
