class DefaultActivityPresenter < ApplicationPresenter
  def present(record)
    super
      .merge(present_project_type(record))
      .merge(present_activity(record))
  end

  def present_project_type(record)
    present_nested(:project_type, ProjectTypePresenter) { record.project_type }
  end

  def present_activity(record)
    present_nested(:activity, ActivityPresenter) { record.activity }
  end
end
