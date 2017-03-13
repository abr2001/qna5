class AddBestToAnswer < ActiveRecord::Migration[5.0]
  def self.up
    add_column :answers, :best, :boolean, default: false
  end
  def self.down
    drop_column :answers, :best
  end
end
