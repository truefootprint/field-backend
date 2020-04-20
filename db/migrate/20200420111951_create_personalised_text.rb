class CreatePersonalisedText < ActiveRecord::Migration[6.0]
  def change
    create_table :personalised_text do |t|
      t.belongs_to :project_role
      t.belongs_to :user_interface_text
      t.jsonb :value, null: false, default: {}
      t.timestamps
    end

    add_index :personalised_text, %i[user_interface_text_id project_role_id],
      name: "personalised_text_index", unique: true
  end
end
