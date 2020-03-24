class CreateUnits < ActiveRecord::Migration[6.0]
  def change
    create_table :units do |t|
      t.text :official_name, null: false
      t.string :type, null: false
      t.jsonb :singular, null: false, default: {}
      t.jsonb :plural, null: false, default: {}
      t.timestamps
    end

    add_index :units, :official_name, unique: true
    add_index :units, :type
  end
end
