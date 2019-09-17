class ProjectActivityPresenter < ApplicationPresenter
  def self.order
    :order
  end

  def present
    { id: record.id, name: record.name, state: record.state }
  end

  class WithProjectQuestions < self
    def present
      presented = presenter_variant.present(record.project_questions)
      super.merge(project_questions: presented)
    end

    def presenter_variant
      ProjectQuestionPresenter
    end

    class ByTopic < self
      def presenter_variant
        ProjectQuestionPresenter::ByTopic
      end
    end
  end
end
