class AddUserToOperations < ActiveRecord::Migration[6.1]
  def change
    add_reference :operations, :user, foreign_key: true
  end
end
