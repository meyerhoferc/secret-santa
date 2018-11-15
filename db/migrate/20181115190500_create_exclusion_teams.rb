class CreateExclusionTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :exclusion_teams do |t|
      t.references :groups, foreign_key: true
      t.string :name
      t.boolean :matched, default: false
      t.datetime :created_at
    end
  end
end
