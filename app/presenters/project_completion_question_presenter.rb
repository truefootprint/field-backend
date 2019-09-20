class ProjectCompletionQuestionPresenter < ApplicationPresenter
  def present(project_question)
    {
      project_question_id: project_question.id,
      completion_value: completion_value(project_question),
    }
  end

  def modify_scope(scope)
    scope.order(:id)
  end

  def completion_value(project_question)
    project_question.question.completion_question.completion_value
  end
end
