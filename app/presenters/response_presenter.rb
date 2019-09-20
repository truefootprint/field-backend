class ResponsePresenter < ApplicationPresenter
  def present(record)
    { project_question_id: record.project_question_id, value: record.value }
  end

  def modify_scope(scope)
    scope.order(created_at: :desc)
  end
end
