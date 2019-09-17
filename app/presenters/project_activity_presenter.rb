class ProjectActivityPresenter
  def self.present(scope)
    scope.order(:order).includes(:activity).map { |pa| new(pa).as_json }
  end

  attr_accessor :project_activity

  def initialize(project_activity)
    self.project_activity = project_activity
  end

  def as_json(_options = {})
    {
      id: project_activity.id,
      name: project_activity.name,
      state: project_activity.state,
    }
  end
end
