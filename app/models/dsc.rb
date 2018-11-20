class Dsc < ApplicationRecord

  def to_mmsi
    station = Station.find_by(id: self.to_id)
    if station
      return station.mmsi
    else
      return "All ships"
    end
  end

  def from_mmsi
    station = Station.find_by(id: self.from_id)
    if station
      return station.mmsi
    else
      return "All ships"
    end
  end
end
