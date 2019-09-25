class UserPresenter < ApplicationPresenter
  def present(record)
    { name: record.name }
  end
end
