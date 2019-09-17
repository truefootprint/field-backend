class ProjectActivityPresenter < ApplicationPresenter
  def self.order
    :order
  end

  def present
    { id: record.id, name: record.name, state: record.state }
  end

  class WithProjectQuestions < self
    def present
      presented = ProjectQuestionPresenter.present(record.project_questions)
      super.merge(project_questions: presented)
    end
  end

  class WithProjectQuestions::ByTopic < self
    def present
      presented = ProjectQuestionPresenter::ByTopic.present(record.project_questions)
      super.merge(project_questions_by_topic: presented)
    end
  end
end
