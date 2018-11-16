class ExclusionTeam < ApplicationRecord
  has_many :user_exclusion_teams
  has_many :users, through: :user_exclusion_teams
  belongs_to :group
end
