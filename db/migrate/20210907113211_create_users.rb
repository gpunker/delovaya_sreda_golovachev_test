class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.decimal :balance, default: 0.0

      t.timestamps
    end
  end
end
