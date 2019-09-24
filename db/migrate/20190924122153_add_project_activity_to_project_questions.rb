class AddProjectActivityToProjectQuestions < ActiveRecord::Migration[6.0]
  def change
    add_reference :project_questions, :project_activity, index: true
  end
end
