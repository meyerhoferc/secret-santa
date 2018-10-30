class Group < ApplicationRecord
  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :lists
  belongs_to :owner, foreign_key: :owner_id, class_name: 'User'
  validates_uniqueness_of :name
  validates :description, presence: true
  validates :owner_id, presence: true

  def user_wish_list(user)
    list = self.lists.where(['user_id = :user_id AND group_id = :group_id',
                     { user_id: user.id, group_id: self.id }])
    list[0]
  end
end
