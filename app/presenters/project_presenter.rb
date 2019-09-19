class ProjectPresenter < ApplicationPresenter
  def present(record)
    { id: record.id, name: record.name }
      .merge(present_current_activity(record))
      .merge(present_activities(record))
  end

  def modify_scope(scope)
    options[:visible] ? scope.visible : scope
  end

  def present_activities(record)
    present_nested(:project_activities,  ProjectActivityPresenter) do
      record.project_activities
    end
  end

  def present_current_activity(record)
    present_nested(:current_project_activity, ProjectActivityPresenter) do |options|
      viewpoint = options.fetch(:for_viewpoint)

      CurrentProjectActivity.for(viewpoint: viewpoint, project: record)
    end
  end
end
