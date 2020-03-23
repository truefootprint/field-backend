class CreateApiTokens < ActiveRecord::Migration[6.0]
  include EncryptedField

  def change
    create_table :api_tokens do |t|
      t.belongs_to :user
      encrypted t, :token, null: false, unique: true

      encrypted t, :device_id
      t.string :device_name
      t.string :device_year_class
      t.string :app_version
      t.string :app_version_code
      t.string :locale
      t.string :time_zone

      t.integer :times_used, null: false, default: 0
      t.datetime :last_used_at
      t.timestamps
    end
  end
end
