class DscsController < ApplicationController
  before_action :set_dsc, only: [:show, :ack, :recieved_call, :listen]
  def ship_station_call
    @dsc = Dsc.new(
      from_id: @current_station.id,
      to_id: Station.find_by(mmsi: params[:mmsi].to_i).id,
      category: "routine",
      format: "individual call",
      message_type: "All modes RT",
      work_ch: params[:work_ch].to_i,
      eos: "ACK RQ"
    )
    @dsc.save
  end

  def show
  end

  def recieved_call
    case @current_station.state
    when 1
      @current_station.state = 6
      @current_station.save
    else
    end
  end

  def listen
    @current_station.state = 1
    @current_station.channel = @dsc.work_ch
    @current_station.save
  end

  def new_call
    @recieved_calls_length = Dsc.where(to_id: [@current_station.id, nil]).length
    @new_call = Dsc.where(to_id: [@current_station.id, nil]).last
    #gon.recieved_calls_length = @recieved_calls_length
    #gon.new_call_id = @new_call.id
    respond_to do |format|
      format.html
      format.json
    end
  end

  def ack
    @ack = Dsc.new(
      from_id: @current_station.id,
      to_id: @from.id,
      category: "routine",
      format: "individual ACK",
      message_type: "All modes RT",
      work_ch: @dsc.work_ch,
      eos: "ACK BQ"
    )
    @ack.save
    @current_station.state = 1
    @current_station.channel = @dsc.work_ch
    @current_station.save
  end

  def set_dsc
    @dsc = Dsc.find_by(id: params[:id])
    @from = Station.find_by(id: @dsc.from_id)
    @to = Station.find_by(id: @dsc.to_id)
    gon.dsc_id = @dsc.id
  end

end
