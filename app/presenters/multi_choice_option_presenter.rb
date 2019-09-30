class MultiChoiceOptionPresenter < ApplicationPresenter
  def modify_scope(scope)
    scope.order(:order)
  end
end
