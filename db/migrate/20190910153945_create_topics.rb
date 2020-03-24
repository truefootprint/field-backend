class CreateTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :topics do |t|
      t.jsonb :name, null: false, default: {}
      t.timestamps
    end

    add_index :topics, :name, unique: true
  end
end
