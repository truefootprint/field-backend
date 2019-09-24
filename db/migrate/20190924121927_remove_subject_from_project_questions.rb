class RemoveSubjectFromProjectQuestions < ActiveRecord::Migration[6.0]
  def change
    remove_reference :project_questions, :subject, polymorphic: true
  end
end
