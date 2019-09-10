class CreateProjectActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :project_activities do |t|
      t.belongs_to :project
      t.belongs_to :activity
      t.string :state
      t.timestamps
    end

    add_index :project_activities, :state
  end
end
