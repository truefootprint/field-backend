class ProjectQuestionPresenter < ApplicationPresenter
  def self.order
    :order
  end

  def as_json(_options = {})
    { id: record.id, text: record.text }
  end

  class ByTopic < self
    def self.present_collection(collection)
      collection.chunk { |pq| pq.question.topic }.map do |topic, project_questions|
        presented_questions = ProjectQuestionPresenter.present(project_questions)

        { topic: TopicPresenter.present(topic), project_questions: presented_questions }
      end
    end
  end
end
