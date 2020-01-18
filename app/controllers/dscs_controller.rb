class DscsController < ApplicationController
  before_action :set_dsc, only: [:show, :ack, :received_call, :listen, :set_lat_long, :accept, :relay, :new_ch, :nack]
  before_action :set_lat_long, only: [:received_call, :show, :accept]
  def ship_station_call
    @dsc = Dsc.new(
      from_id: @current_station.id,
      to_id: Station.find_by(mmsi: params[:mmsi].to_i).id,
      category: "routine",
      format: "Individual call",
      message_type: "All modes RT",
      work_ch: params[:work_ch].to_i,
      eos: "ACK RQ"
    )
    @dsc.save
    @current_station.state = 1
    @current_station.save
  end

  def safety_call_all_ships
    @dsc = Dsc.new(
      from_id: @current_station.id,
      category: "safety",
      format: "All ships call",
      message_type: "All modes RT",
      work_ch: params[:work_ch].to_i,
      eos: "EOS"
    )
    @dsc.save
    @current_station.state = 1
    @current_station.save
  end

  def safety_call_specific_station
    if params[:message_type]
      @message_type = params[:message_type]
    else
      @message_type = "Test"
    end
    @dsc = Dsc.new(
      from_id: @current_station.id,
      to_id: Station.find_by(mmsi: params[:mmsi].to_i).id,
      category: "safety",
      format: "Individual call",
      message_type: @message_type,
      work_ch: params[:work_ch].to_i,
      eos: "ACK RQ"
    )
    @dsc.save
    @current_station.state = 1
    @current_station.save
  end

  def urgency_call_all_ships
    @dsc = Dsc.new(
      from_id: @current_station.id,
      category: "urgency",
      format: "All ships call",
      message_type: "All modes RT",
      work_ch: 16,
      eos: "EOS"
    )
    @dsc.save
    @current_station.state = 1
    @current_station.save
  end

  def urgency_call_specific_station
    @dsc = Dsc.new(
      from_id: @current_station.id,
      to_id: Station.find_by(mmsi: params[:mmsi].to_i).id,
      category: "urgency",
      format: "Individual call",
      message_type: "All modes RT",
      work_ch: 16,
      eos: "ACK RQ"
    )
    @dsc.save
    @current_station.state = 1
    @current_station.save
  end

  def distress_call
    if params[:nature]
      @nature = params[:nature]
    else
      @nature = "Undesignated"
    end
    if params[:lat]
      @lat = params[:lat]
    else
      @lat = @current_station.lat
    end
    if params[:long]
      @long = params[:long]
    else
      @long = @current_station.long
    end
    @dsc = Dsc.new(
      from_id: @current_station.id,
      category: "distress",
      format: "Distress",
      message_type: "Distress",
      nature: @nature,
      lat: @lat,
      long: @long,
      work_ch: 16,
      eos: "EOS"
    )
    @dsc.save
    @current_station.channel = 16
    @current_station.state = 7
    @current_station.save
  end

  def proxy_distress_call_all_ships
    if params[:lat]
      @lat = params[:lat]
    else
      @lat = @current_station.lat
    end
    if params[:long]
      @long = params[:long]
    else
      @long = @current_station.long
    end
    @dsc = Dsc.new(
      from_id: @current_station.id,
      category: "distress",
      format: "Distress",
      message_type: "Proxy distress",
      nature: params[:nature],
      dist_id: params[:dist_id],
      lat: @lat,
      long: @long,
      work_ch: 16,
      eos: "EOS"
    )
    @dsc.save
    @current_station.state = 1
    @current_station.save
  end

  def show
  end

  def received_call
    case @current_station.state
    when 1, 2, 5
      @current_station.state = 6
      @current_station.save
    when 4
    when 7
      if @dsc.message_type == "Distress ACK"
        @current_station.state = 6
        @current_station.save
      end
    else
    end
  end

  def accept
    case @current_station.state
    when 4, 7
      @current_station.state = 6
      @current_station.save
    else
    end
  end

  def listen
    @current_station.state = 1
    if @dsc.work_ch != 0 && @dsc.work_ch != nil && @dsc.message_type != "Unable to comply"
      @current_station.channel = @dsc.work_ch
    end
    @current_station.save
  end

  def cancel
    @current_station.state = 1
    @current_station.save
  end

  def new_call
    @calls = Dsc.where(to_id: [@current_station.id, nil]).where.not(from_id: @current_station.id)
    #@received_calls_length = @calls.length
    if @current_station.region == Station.find_by(id: @calls.last.from_id).region
      @new_call = @calls.last
    end
    #@received_calls_length = Dsc.where(to_id: [@current_station.id, nil]).where.not(from_id: @current_station.id).length
    #@new_call = Dsc.where(to_id: [@current_station.id, nil]).where.not(from_id: @current_station.id).last
    #gon.received_calls_length = @received_calls_length
    #gon.new_call_id = @new_call.id
    respond_to do |format|
      format.html
      format.json
    end
  end

  def ack
    if @dsc.message_type == "Position RQ"
      @ack = Dsc.new(
        from_id: @current_station.id,
        to_id: @from.id,
        category: @dsc.category,
        format: "Individual ACK",
        message_type: "Ship position",
        work_ch: @dsc.work_ch,
        lat: @current_station.lat,
        long: @current_station.long,
        eos: "ACK BQ"
      )
    elsif @dsc.message_type == "Distress"
      @ack = Dsc.new(
        from_id: @current_station.id,
        category: "distress",
        format: "Distress",
        message_type: "Distress ACK",
        dist_id: @from.mmsi,
        nature: @dsc.nature,
        lat: @dsc.lat,
        long: @dsc.long,
        work_ch: 16,
        eos: "EOS"
      )
    elsif @dsc.message_type == "Proxy distress"
      @ack = Dsc.new(
        from_id: @current_station.id,
        category: "distress",
        format: "Distress",
        message_type: "Proxy dist-ACK",
        dist_id: @dsc.dist_id,
        nature: @dsc.nature,
        lat: @dsc.lat,
        long: @dsc.long,
        work_ch: 16,
        eos: "EOS"
      )
    elsif @dsc.message_type == "Distress relay"
      @ack = Dsc.new(
        from_id: @current_station.id,
        to_id: @from.id,
        category: "distress",
        format: "Distress",
        message_type: "Dist-relay ACK",
        dist_id: @dsc.dist_id,
        nature: @dsc.nature,
        lat: @dsc.lat,
        long: @dsc.long,
        work_ch: 16,
        eos: "EOS"
      )
    else
      @ack = Dsc.new(
        from_id: @current_station.id,
        to_id: @from.id,
        category: @dsc.category,
        format: "Individual ACK",
        message_type: @dsc.message_type,
        work_ch: @dsc.work_ch,
        eos: "ACK BQ",
        original_id: @dsc.id
      )
    end
    @ack.save
    @current_station.state = 1
    if @dsc.work_ch != 0 && @dsc.work_ch != nil
      @current_station.channel = @dsc.work_ch
    end
    @current_station.save
  end

  def relay
    if @dsc.message_type == "Distress"
      @relay = Dsc.new(
        from_id: @current_station.id,
        to_id: Station.find_by(mmsi: params[:mmsi].to_i).id,
        category: "distress",
        format: "Distress",
        message_type: "Distress relay",
        dist_id: @from.mmsi,
        nature: @dsc.nature,
        lat: @dsc.lat,
        long: @dsc.long,
        work_ch: 16,
        eos: "EOS"
      )
    elsif @dsc.message_type == "Proxy distress"
      @relay = Dsc.new(
        from_id: @current_station.id,
        to_id: Station.find_by(mmsi: params[:mmsi].to_i).id,
        category: "distress",
        format: "Distress",
        message_type: "Distress relay",
        dist_id: @dsc.dist_id,
        nature: @dsc.nature,
        lat: @dsc.lat,
        long: @dsc.long,
        work_ch: 16,
        eos: "EOS"
      )
    end
    @relay.save
    @current_station.state = 1
    @current_station.save
  end

  def new_ch
    @new_ch = Dsc.new(
      from_id: @current_station.id,
      to_id: @from.id,
      category: @dsc.category,
      format: "Individual ACK",
      message_type: @dsc.message_type,
      work_ch: params[:work_ch].to_i,
      eos: "ACK BQ",
      original_id: @dsc.id
    )
    @new_ch.save
    @current_station.channel = @new_ch.work_ch
    @current_station.state = 1
    @current_station.save
  end

  def nack
    @nack = Dsc.new(
      from_id: @current_station.id,
      to_id: @from.id,
      category: @dsc.category,
      format: "Individual NACK",
      message_type: "Unable to comply",
      reason: params[:reason],
      work_ch: @dsc.work_ch,
      eos: "ACK BQ"
    )
    @nack.save
    @current_station.state = 1
    @current_station.save
  end

  def set_dsc
    @dsc = Dsc.find_by(id: params[:id])
    @from = Station.find_by(id: @dsc.from_id)
    @to = Station.find_by(id: @dsc.to_id)
    gon.dsc_id = @dsc.id
  end

  def set_lat_long
    if @dsc.lat && @dsc.long
      @lat_degree = @dsc.lat.to_i.abs
      lat_min1 = @dsc.lat - @lat_degree.to_f
      lat_min2 = lat_min1.abs * 60
      @lat_min = lat_min2.round
      if @lat_degree < 10
        @lat_degree = "0" + @lat_degree.to_s
      end
      if @lat_min < 10
        @lat_min = "0" + @lat_min.to_s
      end
      @long_degree = @dsc.long.to_i.abs
      long_min1 = @dsc.long - @long_degree.to_f
      long_min2 = long_min1.abs * 60
      @long_min = long_min2.round
      if @long_degree < 10
        @long_degree = "0" + @long_degree.to_s
      end
      if @long_min < 10
        @long_min = "0" + @long_min.to_s
      end
    end
  end

end
