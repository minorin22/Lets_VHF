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
end
