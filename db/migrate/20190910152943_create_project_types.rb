class CreateProjectTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :project_types do |t|
      t.text :name
      t.timestamps
    end

    add_index :project_types, :name, unique: true
  end
end
