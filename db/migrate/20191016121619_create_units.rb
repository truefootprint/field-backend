class CreateUnits < ActiveRecord::Migration[6.0]
  def change
    create_table :units do |t|
      t.text :name, null: false
      t.string :type, null: false
      t.timestamps
    end

    add_index :units, :name, unique: true
    add_index :units, :type
  end
end
