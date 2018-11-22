class Group < ApplicationRecord
  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :lists
  has_many :invitations
  has_many :exclusion_teams
  has_many :santa_assignments
  belongs_to :owner, foreign_key: :owner_id, class_name: 'User'
  validates_uniqueness_of :name, message: 'is already in use.'
  validates :name, presence: true
  validates :description, presence: true
  validates :owner_id, presence: true
  validates :gift_due_date, presence: true
  # validate gift due date is in the future only, on update only!

  def user_wish_list(user)
    self
      .lists
      .where(['user_id = :user_id AND group_id = :group_id',
        { user_id: user.id, group_id: self.id }])
      .first
  end

  def no_exclusion_team_users
    available_users = users.pluck(:user_id) - users_in_exclusion_teams
    User.find(available_users)
  end

  def user_exclusion_team_count
    users_in_exclusion_teams.count
  end

  def users_in_exclusion_teams
    exclusion_teams.joins(:users).pluck(:user_id)
  end
end
