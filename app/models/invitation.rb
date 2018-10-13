class Invitation < ApplicationRecord
  belongs_to :user, foreign_key: :sender_id
  belongs_to :user, foreign_key: :receiver_id
  belongs_to :group
  validates :comment, presence: true
  # validates :accepted, :inclusion => {:in => [true, false]}
end
