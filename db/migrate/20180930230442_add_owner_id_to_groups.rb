class AddOwnerIdToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :owner_id, :integer
    add_reference :groups, :users, foreign_key: true
  end
end
