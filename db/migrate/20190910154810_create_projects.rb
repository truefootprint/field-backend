class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.belongs_to :programme
      t.belongs_to :project_type
      t.text :name, null: false
      t.timestamps
    end

    add_index :projects, :name
  end
end
