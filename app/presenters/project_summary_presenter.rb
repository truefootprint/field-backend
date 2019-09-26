class ProjectSummaryPresenter < ApplicationPresenter
  def present(record)
    { text: record.text }
  end
end
