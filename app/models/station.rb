class Station < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: {maximum: 20}, format: { with: /\A[\u0020-\u007e]+\z/ }
  validates :call_sign, presence: true, uniqueness: true, length: {is: 4}, format: { with: /\A[a-z0-9]+\z/i }

  def transmitted_calls
    return Dsc.where(from_id: self.id)
  end

  def recieved_distress_calls
    return Dsc.where(category: "distress").where(to_id: [self.id, nil]).where.not(from_id: self.id)
  end

  def recieved_others
    return Dsc.where.not(category: "distress").where(to_id: [self.id, nil]).where.not(from_id: self.id)
  end

  include Math

  def get_rng(ship)
    y1 = ship.lat * PI / 180
    x1 = ship.long * PI / 180
    y2 = self.lat * PI / 180
    x2 = self.long * PI / 180
    cos_theta = sin(y1) * sin(y2) + cos(y1) * cos(y2) * cos(x2 - x1)
    return (acos(cos_theta) * 10800 / PI).round(1)
  end

  def get_brg(ship)
    y1 = ship.lat * PI / 180
    x1 = ship.long * PI / 180
    y2 = self.lat * PI / 180
    x2 = self.long * PI / 180
    y = cos(x2) * sin(y2 - y1)
    x = cos(x1) * sin(x2) - sin(x1) * cos(x2) * cos(y2 -y1)
    angle = 180 * atan2(y, x) / PI
    if angle < 0
      angle = (angle + 360) % 360
    end
    return angle.round
  end
end
