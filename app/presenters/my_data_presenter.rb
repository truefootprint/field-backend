class MyDataPresenter < ApplicationPresenter
  def present_collection(projects)
    present_nested(:projects, ProjectPresenter) { projects }
  end

  class WithEverything < self
    def initialize(object, options = {})
      viewpoint = options.fetch(:viewpoint)

      options = options.merge(
        projects: {
          visible: true,
          current_project_activity: {
            for_viewpoint: viewpoint,
          },
          completion_questions: {
            for_viewpoint: viewpoint,
          },
          project_activities: {
            visible: true,
            project_questions: {
              visible: true,
              by_topic: true,
            }
          }
        }
      )

      super(object, options)
    end
  end
end
