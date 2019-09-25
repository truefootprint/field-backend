class CompletionQuestionPresenter < ApplicationPresenter
  def present(record)
    { completion_value: record.completion_value }
  end
end
