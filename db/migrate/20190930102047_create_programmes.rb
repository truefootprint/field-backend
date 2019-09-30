class CreateProgrammes < ActiveRecord::Migration[6.0]
  def change
    create_table :programmes do |t|
      t.text :name
      t.text :description
      t.timestamps
    end
  end
end
