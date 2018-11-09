class Invitation < ApplicationRecord
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :receiver, foreign_key: :receiver_id, class_name: 'User'
  belongs_to :group
  validates :comment, presence: true
  validates_uniqueness_of :receiver_id, scope: :group_id,
                    message: 'has already been invited to this group',
                    conditions: -> { where('(accepted = true) OR (accepted IS NULL)') }
  validates_exclusion_of :sender_id, in: -> (invitation) { [invitation.receiver_id] },
                          message: 'cannot send yourself an invitation'
end
