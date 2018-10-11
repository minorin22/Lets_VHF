class User < ApplicationRecord
  has_secure_password validations: true
  validates :name, {presence: true, uniqueness: true, length: {maximum: 20}, confirmation: true}
  validates :password, {presence: true, length: {maximum: 20}}
end
