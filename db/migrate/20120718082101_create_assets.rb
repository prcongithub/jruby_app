class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :attachable_type
      t.integer :attachable_id
      t.string :attachment_content_type
      t.string :attachment_file_name
      t.integer :attachment_size
      t.integer :position
      t.string :type
      t.datetime :attachment_updated_at
      t.integer :attachment_width
      t.integer :attachment_height
      t.string :group_id
      t.integer :asset_order
      t.integer :user_id
      t.string :name

      t.timestamps
    end
  end
end
