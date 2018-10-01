class Item < ApplicationRecord
  has_one :list
  validates :name, presence: true
  validates :description, presence: true
end
