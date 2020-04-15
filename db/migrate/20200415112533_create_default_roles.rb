class CreateDefaultRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :default_roles do |t|
      t.belongs_to :project_type
      t.belongs_to :role
      t.integer :order, null: false
      t.timestamps
    end

    add_index :default_roles, [:project_type_id, :role_id], unique: true
    add_index :default_roles, :order
  end
end
