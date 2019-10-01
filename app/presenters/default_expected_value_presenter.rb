class DefaultExpectedValuePresenter < ApplicationPresenter
  def present(record)
    super
      .merge(present_question(record))
      .merge(present_activity(record))
  end

  def present_question(record)
    present_nested(:question, QuestionPresenter) { record.question }
  end

  def present_activity(record)
    present_nested(:activity, ActivityPresenter) { record.activity }
  end
end
