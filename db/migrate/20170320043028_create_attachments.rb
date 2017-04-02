class CreateAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :attachments do |t|
      t.string :file
      t.integer :attachable_id
      t.string :attachable_type

      t.timestamps
    end
  end
end
