class Station < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: {maximum: 20}
  validates :call_sign, presence: true, uniqueness: true, length: {is: 4}

end
