class ProjectQuestionPresenter
  def self.present(scope)
    scope.order(:order).includes(:question).map { |pq| new(pq).as_json }
  end

  attr_accessor :project_question

  def initialize(project_question)
    self.project_question = project_question
  end

  def as_json(_options = {})
    {
      id: project_question.id,
      text: project_question.text,
    }
  end

  class ByTopic
    def self.present(scope)
      chunks = scope.order(:order)
        .includes(question: :topic)
        .chunk { |pq| pq.question.topic }

      chunks.map do |topic, pqs|
        presented = TopicPresenter.new(topic).as_json

        presented.merge(project_questions: pqs.map { |pq|
          ProjectQuestionPresenter.new(pq).as_json
        })
      end
    end
  end
end
