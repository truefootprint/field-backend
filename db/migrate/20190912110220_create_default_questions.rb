class CreateDefaultQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :default_questions do |t|
      t.belongs_to :activity
      t.belongs_to :question
      t.integer :order
      t.timestamps
    end

    add_index :default_questions, :order
  end
end
