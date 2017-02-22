class RemoveUserFromAnswer < ActiveRecord::Migration[5.0]
  def change
    remove_column :answers, :user_id
  end
end
