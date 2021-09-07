class AddBalanceToOpertaions < ActiveRecord::Migration[6.1]
  def change
    add_column :operations, :balance, :decimal, default: 0.0
  end
end
