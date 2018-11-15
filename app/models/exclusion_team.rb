class ExclusionTeam < ApplicationRecord
  has_many :user_exclusion_groups
  has_many :users, through: :user_exclusion_groups
  belongs_to :group
end
