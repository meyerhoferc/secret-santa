class User < ApplicationRecord
  has_secure_password
  validates_uniqueness_of :email
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
end
