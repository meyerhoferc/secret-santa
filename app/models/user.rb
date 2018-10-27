class User < ApplicationRecord
  include ActiveModel::Validations

  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :lists
  has_many :invitations

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :username, presence: true
  validates_uniqueness_of :username
  validates :email, presence: true
  validates_uniqueness_of :email
  has_secure_password
  validates :password, password_strength: {use_dictionary: true}
end
