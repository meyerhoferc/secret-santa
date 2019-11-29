class Item < ApplicationRecord
  belongs_to :list
  has_many :comments, as: :commentable
  
  validates :name, presence: true
  validates :description, presence: true
end
