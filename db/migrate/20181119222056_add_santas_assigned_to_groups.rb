class AddSantasAssignedToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :santas_assigned, :boolean, default: false
  end
end
