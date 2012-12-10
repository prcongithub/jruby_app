class CreateUserPreferences < ActiveRecord::Migration
  def change
    create_table :user_preferences do |t|
      t.integer :user_id
      t.integer :item_id
      t.decimal :preference

      t.timestamps
    end
  end
end
