class ProjectQuestionPresenter < ApplicationPresenter
  def present(record)
    { id: record.id, text: record.text }
  end

  def modify_scope(scope)
    scope = scope.order(:order)
    scope = scope.visible if options[:visible]

    scope
  end

  def present_collection(collection)
    return super unless options[:by_topic]

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
