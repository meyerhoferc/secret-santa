class AddDollarLimitToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column(:groups, :dollar_limit, :decimal, precision: 1000, scale: 2, optional: true)
  end
end
