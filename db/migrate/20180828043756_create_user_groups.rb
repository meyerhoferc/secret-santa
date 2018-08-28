class CreateUserGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :user_groups do |t|
      t.integer :user_id, foreign_key: true, index: true
      t.integer :group_id, foreign_key: true, index: true
    end
  end
end
