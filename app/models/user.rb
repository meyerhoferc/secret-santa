class User < ApplicationRecord
  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :lists
  has_many :received, foreign_key: :receiver_id, class_name: 'Invitation'
  has_many :sent, foreign_key: :sender_id, class_name: 'Invitation'
  validates_uniqueness_of :email
  validates_uniqueness_of :id, scope: [:user_groups, :groups]
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true

  has_secure_password
  validates :password, password_strength: {use_dictionary: true}
end
