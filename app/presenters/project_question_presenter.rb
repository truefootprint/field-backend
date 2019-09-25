class ProjectQuestionPresenter < ApplicationPresenter
  def present(record)
    { id: record.id, text: interpolate(record.text) }
      .merge(present_expected_value(record))
      .merge(present_responses(record))
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
      presented_questions = project_questions.map do |pq|
        ProjectQuestionPresenter.present(pq, options)
      end

      {
        topic: TopicPresenter.present(topic, topic_presenter_options),
        project_questions: presented_questions,
      }
    end

    { by_topic: presented }
  end

  private

  def interpolate(string)
    context ? context.apply(string) : string
  end

  def context
    options[:interpolation_context]
  end

  def topic_presenter_options
    { interpolation_context: context }
  end

  def present_expected_value(record)
    present_nested(:expected_value, ExpectedValuePresenter) do
      record.expected_value
    end
  end

  def present_responses(record)
    present_nested(:responses, ResponsePresenter) do |options|
      user = options.fetch(:for_user)

      record.responses.where(user: user)
    end
  end
end
