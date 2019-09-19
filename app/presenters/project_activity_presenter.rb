class ProjectActivityPresenter < ApplicationPresenter
  def present(record)
    { id: record.id, name: record.name }.merge(present_questions(record))
  end

  def modify_scope(scope)
    scope = scope.order(:order)
    scope = scope.visible if options[:visible]

    scope
  end

  def present_questions(record)
    present_nested(:project_questions, ProjectQuestionPresenter) do
      record.project_questions
    end
  end
end
