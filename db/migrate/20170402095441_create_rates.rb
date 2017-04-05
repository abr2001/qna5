class CreateRates < ActiveRecord::Migration[5.0]
  def change
    create_table :rates do |t|
      t.integer :value
      t.belongs_to :user, foreign_key: true
      t.integer :ratable_id
      t.string :ratable_type

      t.timestamps
    end
    add_index :rates, [:ratable_id, :ratable_type]
    add_index :rates, [:user_id, :ratable_id, :ratable_type], unique: true
  end
end
