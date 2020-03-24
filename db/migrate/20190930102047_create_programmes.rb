class CreateProgrammes < ActiveRecord::Migration[6.0]
  def change
    create_table :programmes do |t|
      t.jsonb :name, null: false, default: {}
      t.jsonb :description, null: false, default: {}
      t.timestamps
    end
  end
end
