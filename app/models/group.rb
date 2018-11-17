class Group < ApplicationRecord
  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :lists
  has_many :invitations
  has_many :exclusion_teams
  has_many :santa_assignments
  validates :name, presence: true
  validates_uniqueness_of :name, message: 'is already in use.'
  validates :description, presence: true
  belongs_to :owner, foreign_key: :owner_id, class_name: 'User'
  validates :owner_id, presence: true
  validates :gift_due_date, presence: true
  # validate gift due date is in the future only, on update only!

  def user_wish_list(user)
    list = self.lists.where(['user_id = :user_id AND group_id = :group_id',
                     { user_id: user.id, group_id: self.id }])
    list.first
  end

  def no_exclusion_team_users
    available_users = users.pluck(:user_id) - exclusion_teams.joins(:users).pluck(:user_id)
    User.find(available_users)
  end
end
