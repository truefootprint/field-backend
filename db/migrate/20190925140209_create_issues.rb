class CreateIssues < ActiveRecord::Migration[6.0]
  def change
    create_table :issues do |t|
      t.string :uuid, null: false
      t.belongs_to :subject, polymorphic: true
      t.belongs_to :user
      t.boolean :critical, null: false, default: false
      t.timestamps
    end

    add_index :issues, :critical
  end
end
