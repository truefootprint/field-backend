class CompletionQuestionPresenter < ApplicationPresenter
  def present(record)
    { question_id: record.question_id, completion_value: record.completion_value }
  end
end
