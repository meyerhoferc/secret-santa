class Invitation < ApplicationRecord
  belongs_to :user, foreign_key: :sender_id
  belongs_to :user, foreign_key: :receiver_id
  belongs_to :group
  validates :comment, presence: true
  validates_uniqueness_of :receiver_id, scope: :group_id,
                    message: 'has already been invited to this group'
  validates_exclusion_of :sender_id, in: -> (invitation) { [invitation.receiver_id] },
                          message: 'cannot send yourself an invitation'
end
