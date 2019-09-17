class ProjectQuestionPresenter < ApplicationPresenter
  def self.order
    :order
  end

  def as_json(_options = {})
    { id: record.id, text: record.text }
  end

  class ByTopic < self
    def self.present_collection(collection)
      chunks = collection.chunk { |pq| pq.question.topic }

      presented = chunks.map do |topic, project_questions|
        {
          topic: TopicPresenter.present(topic),
          project_questions: ProjectQuestionPresenter.present(project_questions),
        }
      end

      { by_topic: presented }
    end
  end
end
