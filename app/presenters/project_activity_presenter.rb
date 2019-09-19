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
    o = options[:project_questions] or return {}

    { project_questions: ProjectQuestionPresenter.present(record.project_questions, o) }
  end
end
