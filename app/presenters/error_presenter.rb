class ErrorPresenter < ApplicationPresenter
  def present(record)
    super.merge(
      message: record.errors.full_messages.join(", "),
      error: {
        messages: record.errors.messages,
        full_messages: record.errors.full_messages,
      }
    )
  end
end
