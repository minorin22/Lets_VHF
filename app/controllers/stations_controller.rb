class StationsController < ApplicationController
  before_action :set_station, only: [:show, :edit, :update, :destroy, :back_16, :btns]
  def index
  end

  def show
    if @station.channel != 16
      @station.channel = 16
    end
    if @station.state != 1
      @station.state = 1
    end
    if @station.tmp_ch
      @station.tmp_ch = nil
    end
    @station.save
    @lat_degree = @station.lat.to_i.abs
    lat_min1 = @station.lat - @lat_degree.to_f
    lat_min2 = lat_min1.abs * 60
    @lat_min = lat_min2.round
    if @lat_degree < 10
      @lat_degree = "0" + @lat_degree.to_s
    end
    if @lat_min < 10
      @lat_min = "0" + @lat_min.to_s
    end
    @long_degree = @station.long.to_i.abs
    long_min1 = @station.long - @long_degree.to_f
    long_min2 = long_min1.abs * 60
    @long_min = long_min2.round
    if @long_degree < 10
      @long_degree = "0" + @long_degree.to_s
    end
    if @long_min < 10
      @long_min = "0" + @long_min.to_s
    end

  end

  def new
    @station = Station.new
  end

  def back_16
    @station.channel = 16
    @station.state = 1
    if @station.tmp_ch
      @station.tmp_ch = nil
    end
    @station.save
  end


  def btns
    num = params[:num].to_i
    case @station.state
    when 1
      @station.tmp_ch = num
      @station.state = 2
      @station.save
    when 2
      @station.channel = @station.tmp_ch * 10 + num
      @station.state = 1
      @station.save
    else
      render "stations/show"
      return
    end
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
      channel: 16,
      state: 1
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

  def set_station
    @station = Station.find_by(id: params[:id])
  end
end
