class DscsController < ApplicationController
  before_action :set_dsc, only: [:show, :ack]
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
  end

end
