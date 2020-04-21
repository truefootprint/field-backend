class UserInterfaceTextPresenter < ApplicationPresenter
  def present(record)
    { id: record.id, key: record.key, value: record.value }
  end
end
