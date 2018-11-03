class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.text :name
      t.text :description
      t.text :note
      t.text :size
      t.references :list, foreign_key: true
    end
  end
end
