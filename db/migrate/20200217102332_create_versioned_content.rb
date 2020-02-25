class CreateVersionedContent < ActiveRecord::Migration[6.0]
  def change
    create_table :versioned_contents do |t|
      t.belongs_to :subject, polymorphic: true
      t.belongs_to :user

      t.string :ancestry # Uses the ancestry gem

      t.text :text, null: false
      t.text :photos_json, null: false

      t.timestamps
    end

    add_index :versioned_contents, :ancestry
    add_index :versioned_contents, :photos_json

    add_index :versioned_contents, :created_at
    add_index :versioned_contents, :updated_at
  end
end
