class Group < ApplicationRecord
  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :lists
  belongs_to :user, foreign_key: :owner_id
  validates_uniqueness_of :name
  validates :description, presence: true
  validates :owner_id, presence: true
end