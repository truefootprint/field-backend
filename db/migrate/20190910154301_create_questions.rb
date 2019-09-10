class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.belongs_to :topic
      t.text :text
      t.timestamps
    end

    add_index :questions, [:topic_id, :text], unique: true
  end
end
