class CreateUserInterfaceText < ActiveRecord::Migration[6.0]
  def change
    create_table :user_interface_text do |t|
      t.string :key, null: false
      t.jsonb :value, null: false, default: {}
      t.timestamps
    end

    add_index :user_interface_text, :key, unique: true
  end
end
