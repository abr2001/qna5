class AddUserIdIntegerIntoAnswer < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :user_id, :integer, null: false
  end
end
