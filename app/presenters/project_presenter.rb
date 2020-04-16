class ProjectPresenter < ApplicationPresenter
  def present(record)
    super
      .merge(present_project_summary(record))
      .merge(present_source_materials(record))
      .merge(present_current_activity(record))
      .merge(present_activities(record))
      .merge(present_issues(record))
  end

  def modify_scope(scope)
    options[:visible] ? scope.visible : scope
  end

  def present_project_summary(record)
    present_nested(:project_summary, ProjectSummaryPresenter) { record.project_summary }
  end

  def present_source_materials(record)
    present_nested(:source_materials, SourceMaterialPresenter) { record.source_materials }
  end

  def present_current_activity(record)
    present_nested(:current_project_activity, ProjectActivityPresenter) do |options|
      viewpoint = options.fetch(:for_viewpoint)

      CurrentProjectActivity.for(viewpoint: viewpoint, project: record)
    end
  end

  def present_activities(record)
    present_nested(:project_activities,  ProjectActivityPresenter) do
      record.project_activities.order(:id)
    end
  end

  def present_issues(record)
    present_nested(:issues, IssuePresenter) { record.issues }
  end
end
