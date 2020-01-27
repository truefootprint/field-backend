class CreateApiTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :api_tokens do |t|
      t.belongs_to :user

      t.string :encrypted_token, null: false
      t.string :encrypted_token_iv, null: false
      t.string :encrypted_device_id
      t.string :encrypted_device_id_iv
      t.string :device_name
      t.string :device_year_class
      t.string :app_version
      t.string :app_version_code

      t.integer :times_used, null: false, default: 0
      t.datetime :last_used_at
      t.timestamps
    end

    add_index :api_tokens, :encrypted_token_iv, unique: true
    add_index :api_tokens, :encrypted_device_id_iv, unique: true
  end
end
