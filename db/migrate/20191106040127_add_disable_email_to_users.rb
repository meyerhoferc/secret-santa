class AddDisableEmailToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :disable_email, :boolean, default: false
  end
end
