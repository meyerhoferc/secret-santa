class CreateUserExclusionTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :user_exclusion_teams do |t|
      t.integer :user_id, foreign_key: true, index: true
      t.integer :exclusion_team_id, foreign_key: true, index: true
    end
  end
end
