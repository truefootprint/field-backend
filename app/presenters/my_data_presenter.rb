class MyDataPresenter < ApplicationPresenter
  def present_scope(projects)
    present_nested(:projects, ProjectPresenter) { projects }
  end

  class WithEverything < self
    def initialize(object, options = {})
      viewpoint = options.fetch(:viewpoint)

      options = options.merge(
        projects: {
          visible: true,
          project_summary: true,
          source_materials: true,
          current_project_activity: {
            for_viewpoint: viewpoint,
          },
          project_activities: {
            visible: true,
            source_materials: true,
            project_questions: {
              visible: true,
              by_topic: true,
              completion_question: true,
              expected_value: {
                source_materials: true,
              },
              responses: {
                for_user: viewpoint.user,
              },
              issues: {
                user: true,
                photos: true,
                resolution: {
                  user: true,
                  photos: true,
                },
              },
            },
            issues: {
              user: true,
              photos: true,
              resolution: {
                user: true,
                photos: true,
              },
            },
          },
          issues: {
            user: true,
            photos: true,
            resolution: {
              user: true,
              photos: true,
            },
          },
        },
      )

      super(object, options)
    end
  end
end
