class MyDataPresenter < ApplicationPresenter
  def present(projects:, completion_questions:)
    presented = present_nested(:projects, ProjectPresenter) { projects }

    presented.merge(
      present_nested(:completion_questions, CompletionQuestionPresenter) { completion_questions }
    )
  end

  class WithEverything < self
    def initialize(object, options = {})
      viewpoint = options.fetch(:viewpoint)

      options = options.merge(
        completion_questions: true,
        projects: {
          visible: true,
          current_project_activity: {
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
