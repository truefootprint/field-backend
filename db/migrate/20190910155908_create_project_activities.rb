class CreateProjectActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :project_activities do |t|
      t.belongs_to :project
      t.belongs_to :activity
      t.integer :order
      t.timestamps
    end

    add_index :project_activities, :order
  end
end
