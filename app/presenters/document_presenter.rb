class DocumentPresenter < ApplicationPresenter
  def present(record)
    { path: record.path }
  end
end
