class ErrorPresenter < ApplicationPresenter
  def present(record)
    {
      error: {
        messages: record.errors.messages,
        full_messages: record.errors.full_messages,
      },
    }
  end
end
