class List < ApplicationRecord
  belongs_to :group
  belongs_to :user
  has_many :comments, as: :commentable
  has_many :items
end
