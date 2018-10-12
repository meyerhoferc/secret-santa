class CreateInvitations < ActiveRecord::Migration[5.2]
  def change
    create_table :invitations do |t|
      t.references :group, foreign_key: true
      t.references :receiver_id, foreign_key: {to_table: :users}
      t.references :sender_id, foreign_key: {to_table: :users}
      t.text :comment
      t.boolean :accepted
      t.timestamps
    end
  end
end
