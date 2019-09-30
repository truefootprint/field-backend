class QuestionPresenter < ApplicationPresenter
  def present(record)
    { id: record.id, text: record.text }
  end
end
