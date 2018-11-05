class DscsController < ApplicationController

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
    @dsc = Dsc.find_by(id: params[:id])
    @from = Station.find_by(id: @dsc.from_id)
    @to = Station.find_by(id: @dsc.to_id)
  end

end
