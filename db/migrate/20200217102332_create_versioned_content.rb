class CreateVersionedContent < ActiveRecord::Migration[6.0]
  def change
    create_table :versioned_contents do |t|
      t.belongs_to :subject, polymorphic: true
      t.belongs_to :user

      t.string :ancestry # Uses the ancestry gem

      t.text :content, null: false
      t.jsonb :photos, null: false

      t.timestamps
    end

    add_index :versioned_contents, :ancestry
    add_index :versioned_contents, :photos

    add_index :versioned_contents, :created_at
    add_index :versioned_contents, :updated_at
  end
end
