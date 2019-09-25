class ResponsePresenter < ApplicationPresenter
  def present(record)
    { value: record.value }
  end

  def modify_scope(scope)
    scope.order(created_at: :desc)
  end
end
