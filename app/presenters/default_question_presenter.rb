class DefaultQuestionPresenter < ApplicationPresenter
  def present(record)
    super
      .merge(present_activity(record))
      .merge(present_question(record))
  end

  def present_activity(record)
    present_nested(:activity, ActivityPresenter) { record.activity }
  end

  def present_question(record)
    present_nested(:question, QuestionPresenter) { record.question }
  end
end
