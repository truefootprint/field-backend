class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :country_code, null: false

      t.string :encrypted_phone_number, null: false
      t.string :encrypted_phone_number_iv, null: false

      t.timestamps
    end

    add_index :users, :name
    add_index :users, :encrypted_phone_number_iv, unique: true
  end
end
