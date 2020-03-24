class CreateActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :activities do |t|
      t.jsonb :name, null: false, default: {}
      t.timestamps
    end

    add_index :activities, :name, unique: true
  end
end
