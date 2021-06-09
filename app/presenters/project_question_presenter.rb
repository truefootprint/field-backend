class ProjectQuestionPresenter < ApplicationPresenter
  def present(record)
    super
      .merge(
        data_type: record.data_type,
        type: record.type,
        text: interpolate(record.text),
        issues_possible: record.question.issues_possible
      )
      .merge(present_type_specific_fields(record))
      .merge(present_completion_question(record))
      .merge(present_expected_value(record))
      .merge(present_responses(record))
      .merge(present_issues(record))
      .merge(present_unit(record))
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

  def options
    super.merge(multi_choice_options: true)
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

  def present_type_specific_fields(record)
    question = record.question

    case question
    when FreeTextQuestion
      { expected_length: question.expected_length }
    when MultiChoiceQuestion
      { multiple_answers: question.multiple_answers }.merge(present_options(record))
    else
      {}
    end
  end

  def present_options(record)
    present_nested(:multi_choice_options, MultiChoiceOptionPresenter) do
      record.question.multi_choice_options
    end
  end

  def present_completion_question(record)
    present_nested(:completion_question, CompletionQuestionPresenter) do
      record.completion_question
    end
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

  def present_issues(record)
    present_nested(:issues, IssuePresenter) { record.issues }
  end

  def present_unit(record)
    present_nested(:unit, UnitPresenter) do
      record.question.unit
    end
  end
end
