class ProjectPresenter < ApplicationPresenter
  def present(record)
    { id: record.id, name: record.name }.merge(present_activities(record))
  end

  def modify_scope(scope)
    options[:visible] ? scope.visible : scope
  end

  def present_activities(record)
    o = options[:project_activities] or return {}

    { project_activities: ProjectActivityPresenter.present(record.project_activities, o) }
  end

  class WithEverything < self
    def options
      {
        visible: true,
        project_activities: {
          visible: true,
          project_questions: {
            visible: true,
            by_topic: true,
          }
        }
      }
    end
  end
end
