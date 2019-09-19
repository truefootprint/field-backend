class MyDataPresenter < ApplicationPresenter
  def present(projects:, completion_questions:)
    present_projects(projects).merge(present_completion_questions(completion_questions))
  end

  def present_projects(projects)
    o = options[:projects] or return {}
    { projects: ProjectPresenter.present(projects, o) }
  end

  def present_completion_questions(completion_questions)
    o = options[:completion_questions] or return {}
    { completion_questions: CompletionQuestionPresenter.present(completion_questions, o) }
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
