class CreateDefaultActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :default_activities do |t|
      t.belongs_to :project_type
      t.belongs_to :activity
      t.integer :order
      t.timestamps
    end

    add_index :default_activities, :order
  end
end
