class CreateTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :topics do |t|
      t.text :name, null: false
      t.timestamps
    end

    add_index :topics, :name, unique: true
  end
end
