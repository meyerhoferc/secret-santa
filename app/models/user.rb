class User < ApplicationRecord
  has_many :user_groups
  has_many :groups, through: :user_groups
  belongs_to :group
  has_secure_password
  validates_uniqueness_of :email
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
end
