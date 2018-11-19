class AddSantaMessageToLists < ActiveRecord::Migration[5.2]
  def change
    add_column :lists, :santa_message, :text
  end
end
