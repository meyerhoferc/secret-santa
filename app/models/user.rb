class User < ApplicationRecord

  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :lists
  has_many :invitations
  validates_uniqueness_of :email
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true

  include ActiveModel::Validations
  has_secure_password
  validates :password, password_strength: {use_dictionary: true}
end
