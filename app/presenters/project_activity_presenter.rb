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

  class WithProjectQuestions
    class ByTopic
      def self.present(scope)
        scope.includes(:activity, :project_questions).map do |pa|
          presented = ProjectActivityPresenter.new(pa).as_json

          # TODO: re-work the presenter methods
          project_questions = ProjectQuestion.where(id: pa.project_questions)
          presented_questions = ProjectQuestionPresenter::ByTopic.present(project_questions)

          presented.merge(project_questions: presented_questions)
        end
      end
    end
  end
end
