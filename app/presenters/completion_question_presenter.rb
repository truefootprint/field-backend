class CompletionQuestionPresenter < ApplicationPresenter
  def present(record)
    super.merge(present_question(record))
  end

  def present_question(record)
    present_nested(:question, QuestionPresenter) { record.question }
  end
end
