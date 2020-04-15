class CreateRegistrations < ActiveRecord::Migration[6.0]
  def change
    create_table :registrations do |t|
      t.belongs_to :user
      t.belongs_to :project_role
      t.belongs_to :project_activity, optional: true
      t.timestamps
    end

    add_index :registrations, [:user_id, :project_role_id, :project_activity_id],
      name: "registrations_index", unique: true
  end
end
