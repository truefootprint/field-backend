class CreateProjectQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :project_questions do |t|
      t.belongs_to :subject, polymorphic: true
      t.belongs_to :question
      t.timestamps
    end
  end
end
