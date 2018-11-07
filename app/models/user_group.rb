class UserGroup < ApplicationRecord
  belongs_to :user
  belongs_to :group
  validates_uniqueness_of :user_id, scope: :group_id, message: 'already belongs to this group.'
end
