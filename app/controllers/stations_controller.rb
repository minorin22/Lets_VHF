class StationsController < ApplicationController
  before_action :set_station, only: [:show, :edit, :update, :destroy, :back_16, :btns, :change_power, :cancel, :off_btn, :pwr_off, :pwr_cont, :menu, :func, :dsc_rtn, :safety_call_all_ships ,:safety_call_specific_station, :urgency_call_all_ships, :urgency_call_specific_station, :distress_call, :break]
  before_action :authenticate_user
  before_action :authenticate_station, only: [:show, :edit, :update, :destroy]
  before_action :ensure_correct_station, only: [:show, :edit, :update, :destroy]
  before_action :forbid_login_station, only: [:new, :create]
  before_action :set_lat_long, only: [:show, :distress_call]
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
    if @station.power = 1
      @station.power = 25
    end
    @station.save
  end

  def new
    @station = Station.new
  end

  def pwr_cont
    case @station.state
    when 0
      @station.state = 1
      @station.channel = 16
      @station.tmp_ch = nil
      @station.power = 25
      @station.save
    else
      render "stations/show"
      return
    end
  end

  def pwr_off
    @station.state = 0
    @station.save
  end

  def change_power
    case @station.state
    when 1, 3
      if @station.power != 1
        @station.power = 1
        @station.save
      else
        @station.power = 25
        @station.save
      end
    else
      render "stations/show"
      return
    end
  end

  def back_16
    case @station.state
    when 1, 2, 3
      @station.channel = 16
      @station.state = 1
      if @station.tmp_ch
        @station.tmp_ch = nil
      end
    else
      render "stations/show"
      return
    end
    @station.save
  end

  def menu
    @category = {routine: "RTN", safety: "SAF", urgency: "URG", distress: "DIST"}
    @format = {"Individual call" => "INDIV", "Individual ACK" => "ACK", "Individual NACK" => "NACK", "All ships call" => "ALL" , "Distress" => "DIST"}
    @type = {"Distress" => "Distress", "Distress ACK" => "ACK", "Distress relay" => "Relay", "Dist-relay ACK" => "Relay-ACK", "Proxy distress" => "Proxy", "Proxy dist-ACK" => "Proxy-ACK"}
    case @station.state
    when 1, 4
      @station.state = 4
      @station.save
    else
      render "stations/show"
      return
    end
  end

  def cancel
    case @station.state
    when 1, 2, 3, 4, 5
      @station.state = 1
      @station.save
    when 7
    else
      render "stations/show"
      return
    end
  end

  def break
    case @station.state
    when 7
      @station.state = 1
      @station.save
      render "stations/show"
      return
    end
  end

  def off_btn
    case @station.state
    when 1
      @station.state = 3
      @station.save
    else
      render "stations/show"
      return
    end
  end

  def func
    case @station.state
    when 1
      @station.state = 5
      @station.save
    when 5
      @station.state = 1
      @station.save
    else
      render "stations/show"
    end
  end

  def dsc_rtn
    case @station.state
    when 1
      @station.state = 4
      @station.save
    when 4
    else
      render "stations/show"
    end
  end

  def safety_call_all_ships
    dsc_rtn
  end

  def safety_call_specific_station
    dsc_rtn
  end

  def urgency_call_all_ships
    dsc_rtn
  end

  def urgency_call_specific_station
    dsc_rtn
  end

  def distress_call
    dsc_rtn
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
    when 5
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
      lat: rand(35.444...35.619),
      long: rand(139.792...140.222),
      region: params[:region],
      channel: 16,
      state: 1,
      power: 25
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
    gon.station_id = @station.id
  end

  def set_lat_long
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

  def ensure_correct_station
    if @current_station.id != params[:id].to_i
      flash[:notice] = "権限がありません"
      redirect_to("/stations/#{@current_station.id}")
    end
  end

end
