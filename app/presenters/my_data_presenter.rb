class MyDataPresenter < ApplicationPresenter
  def present(projects:, responses:)
    presented_projects = present_nested(:projects, ProjectPresenter) { projects }
    presented_responses = present_nested(:responses, ResponsePresenter) { responses }

    presented_projects.merge(presented_responses)
  end

  class WithEverything < self
    def initialize(object, options = {})
      viewpoint = options.fetch(:viewpoint)

      options = options.merge(
        projects: {
          visible: true,
          source_materials: true,
          current_project_activity: {
            for_viewpoint: viewpoint,
          },
          completion_questions: {
            for_viewpoint: viewpoint,
          },
          project_activities: {
            visible: true,
            source_materials: true,
            project_questions: {
              visible: true,
              by_topic: true,
              expected_value: {
                source_materials: true,
              },
            }
          }
        },
        responses: true,
      )

      super(object, options)
    end
  end
end
