class CreateUsers < ActiveRecord::Migration[6.0]
  include EncryptedField

  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :country_code, null: false
      encrypted t, :phone_number, null: false, unique: true

      t.timestamps
    end

    add_index :users, :name
  end
end
