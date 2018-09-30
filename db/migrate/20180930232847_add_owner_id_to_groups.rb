class AddOwnerIdToGroups < ActiveRecord::Migration[5.2]
  def change
    add_reference :groups, :user, foreign_key: true
    rename_column :groups, :user_id, :owner_id
  end
end
