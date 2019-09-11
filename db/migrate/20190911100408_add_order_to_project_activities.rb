class AddOrderToProjectActivities < ActiveRecord::Migration[6.0]
  def change
    add_column :project_activities, :order, :integer
    add_index :project_activities, :order
  end
end
