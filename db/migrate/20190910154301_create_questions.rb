class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.belongs_to :topic
      t.string :type
      t.text :text
      t.integer :expected_length
      t.boolean :multiple_answers, null: false, default: false
      t.timestamps
    end

    add_index :questions, [:topic_id, :text], unique: true
    add_index :questions, :type
  end
end
