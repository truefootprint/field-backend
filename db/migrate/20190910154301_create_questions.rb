class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.belongs_to :topic
      t.belongs_to :unit, optional: true
      t.string :type, null: false
      t.string :data_type, null: false
      t.text :text, null: false
      t.integer :expected_length
      t.boolean :multiple_answers, null: false, default: false
      t.timestamps
    end

    add_index :questions, [:topic_id, :text], unique: true
    add_index :questions, :type
    add_index :questions, :data_type
  end
end
