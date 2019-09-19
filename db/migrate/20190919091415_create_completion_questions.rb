class CreateCompletionQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :completion_questions do |t|
      t.belongs_to :question, index: { unique: true }
      t.text :completion_value
      t.timestamps
    end
  end
end
