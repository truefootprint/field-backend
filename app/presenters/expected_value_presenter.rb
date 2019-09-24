class ExpectedValuePresenter < ApplicationPresenter
  def present(record)
    { value: record.value }
  end
end
