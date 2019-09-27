class MultiChoiceOptionPresenter < ApplicationPresenter
  def modify_scope(scope)
    scope.order(:order)
  end

  def present(record)
    { text: record.text }
  end
end
