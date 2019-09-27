class CreateActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :activities do |t|
      t.text :name, null: false
      t.timestamps
    end

    add_index :activities, :name, unique: true
  end
end
