class MyDataPresenter < ApplicationPresenter
  def present_scope(projects)
    present_projects(projects)
      .merge(present_user)
      .merge(present_user_interface_text)
  end

  def present_projects(projects)
    present_nested(:projects, ProjectPresenter) { projects }
  end

  def present_user
    present_nested(:user, UserPresenter) { |opts| opts.fetch(:for_user) }
  end

  def present_user_interface_text
    present_nested(:user_interface_text, UserInterfaceTextPresenter) do
      UserInterfaceText.all
    end
  end

  class WithEverything < self
    def initialize(object, options = {})
      viewpoint = options.fetch(:viewpoint)

      options = options.merge(
        user_interface_text: true,
        user: {
          for_user: viewpoint.user,
        },
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
              unit: true,
              expected_value: {
                source_materials: true,
                unit: true,
              },
              responses: {
                for_user: viewpoint.user,
                unit: true,
                photos: true,
              },
              issues: {
                user: true,
                notes: {
                  user: true,
                  photos: true,
                },
              },
            },
            issues: {
              user: true,
              notes: {
                user: true,
                photos: true,
              },
            },
          },
          issues: {
            user: true,
            notes: {
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
