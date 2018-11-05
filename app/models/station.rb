class Station < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: {maximum: 20}
  validates :call_sign, presence: true, uniqueness: true, length: {is: 4}

  def transmitted_calls
    return Dsc.where(from_id: self.id)
  end

  def recieved_distress_calls
    return Dsc.where(category: "distress").where(to_id: [self.id, nil])
  end

  def recieved_others
    return Dsc.where.not(category: "distress").where(to_id: [self.id, nil])
  end
end
