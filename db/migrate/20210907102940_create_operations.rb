class CreateOperations < ActiveRecord::Migration[6.1]
  def change
    create_table :operations do |t|
      t.string :name, null: false
      t.integer :op_type, default: 1
      t.decimal :total, default: 0.0
      t.datetime :operation_date, default: -> { 'NOW()' }

      t.timestamps
    end
  end
end
