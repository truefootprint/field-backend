class CreateProjectQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :project_questions do |t|
      t.belongs_to :project_activity
      t.belongs_to :question
      t.integer :order
      t.timestamps
    end

    add_index :project_questions, :order
  end
end
