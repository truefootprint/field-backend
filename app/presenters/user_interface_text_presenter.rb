class UserInterfaceTextPresenter < ApplicationPresenter
  def present(record)
    { key: record.key, value: record.value }
  end
end
