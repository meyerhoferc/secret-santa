class SantaAssignment < ApplicationRecord
  belongs_to :santa, foreign_key: :santa_id, class_name: 'User'
  belongs_to :recipient, foreign_key: :receiver_id, class_name: 'User'
  belongs_to :group
end
