class UserExclusionTeam < ApplicationRecord
  belongs_to :user
  belongs_to :exclusion_team
  validates_uniqueness_of :user_id, scope: :exclusion_team_id, message: 'already belongs to this team.'
end
