class CreateProjectRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :project_roles do |t|
      t.belongs_to :project
      t.belongs_to :role
      t.timestamps
    end

    add_index :project_roles, [:project_id, :role_id], unique: true
  end
end
