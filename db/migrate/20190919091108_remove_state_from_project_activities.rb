class RemoveStateFromProjectActivities < ActiveRecord::Migration[6.0]
  def change
    remove_index :project_activities, :state
    remove_column :project_activities, :state, :string
  end
end
