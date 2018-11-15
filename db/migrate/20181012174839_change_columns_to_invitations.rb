class ChangeColumnsToInvitations < ActiveRecord::Migration[5.2]
  def change
    rename_column(:invitations, :receiver_id_id, :receiver_id)
    rename_column(:invitations, :sender_id_id, :sender_id)
  end
end
