class ExclusionTeam < ApplicationRecord
  has_many :user_exclusion_teams
  has_many :users, through: :user_exclusion_teams
  belongs_to :group

  validates :name, presence: true
  validates_uniqueness_of :name, scope: :group, message: 'already in use.'
end
