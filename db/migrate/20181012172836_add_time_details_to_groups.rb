class AddTimeDetailsToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :gift_due_date, :date
    add_column :groups, :year, :date
    add_timestamps :groups, null: true

  end
end
