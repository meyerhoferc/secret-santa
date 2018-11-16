class CreateSantaAssignments < ActiveRecord::Migration[5.2]
  def change
    create_table :santa_assignments do |t|
      t.references :group, foreign_key: true
      t.references :santa, foreign_key: {to_table: :users}
      t.references :receiver, foreign_key: {to_table: :users}
      t.datetime :created_at
    end
  end
end
