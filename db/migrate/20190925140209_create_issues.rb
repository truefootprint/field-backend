class CreateIssues < ActiveRecord::Migration[6.0]
  def change
    create_table :issues do |t|
      t.belongs_to :subject, polymorphic: true
      t.belongs_to :user
      t.text :description, null: false
      t.boolean :critical, null: false, default: false
      t.timestamps
    end

    add_index :issues, :critical
  end
end
