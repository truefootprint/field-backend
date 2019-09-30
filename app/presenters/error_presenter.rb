class ErrorPresenter < ApplicationPresenter
  def present(record)
    super.merge(error: {
      messages: record.errors.messages,
      full_messages: record.errors.full_messages,
    })
  end
end
