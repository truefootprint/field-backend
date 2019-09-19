class MyDataPresenter < ApplicationPresenter
  def present(projects:, completion_questions:)
    present_nested(:projects, projects, ProjectPresenter).merge(
      present_nested(:completion_questions, completion_questions, CompletionQuestionPresenter)
    )
  end

  class WithEverything < self
    def options
      {
        completion_questions: true,
        projects: {
          visible: true,
          project_activities: {
            visible: true,
            project_questions: {
              visible: true,
              by_topic: true,
            }
          }
        },
      }
    end
  end
end
