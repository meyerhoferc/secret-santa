class Group < ApplicationRecord
  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :lists
  has_many :invitations
  validates_uniqueness_of :name
  validates :name, presence: true
  validates :description, presence: true
  belongs_to :owner, foreign_key: :owner_id, class_name: 'User'
  validates :owner_id, presence: true
  validates :gift_due_date, presence: true

  def user_wish_list(user)
    list = self.lists.where(['user_id = :user_id AND group_id = :group_id',
                     { user_id: user.id, group_id: self.id }])
    list[0]
  end
end
