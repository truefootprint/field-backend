class CreateIssueNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :issue_notes do |t|
      t.belongs_to :issue
      t.belongs_to :user
      t.text :text
      t.text :photos_json
      t.boolean :resolved, null: false, default: false
      t.timestamps
    end

    add_index :issue_notes, :photos_json
    add_index :issue_notes, :resolved
  end
end
