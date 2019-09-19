class ProjectPresenter < ApplicationPresenter
  def present(record)
    { id: record.id, name: record.name }.merge(present_activities(record))
  end

  def modify_scope(scope)
    options[:visible] ? scope.visible : scope
  end

  def present_activities(record)
    present_nested(:project_activities, record.project_activities, ProjectActivityPresenter)
  end
end
