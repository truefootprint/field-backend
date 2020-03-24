class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.belongs_to :programme
      t.belongs_to :project_type
      t.jsonb :name, null: false, default: {}
      t.timestamps
    end

    add_index :projects, :name
  end
end
