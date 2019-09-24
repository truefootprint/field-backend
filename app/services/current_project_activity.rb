class CurrentProjectActivity
  def self.for(**params)
    new(**params).current_project_activity
  end

  attr_accessor :viewpoint, :project

  def initialize(viewpoint:, project:)
    self.viewpoint = viewpoint
    self.project = project
  end

  def current_project_activity
    unfinished_activities
      .visible_to(viewpoint)
      .with_visible_project_questions(viewpoint)
      .order(:order)
      .first
  end

  private

  def unfinished_activities
    project_activities.where.not(id: finished_activities)
  end

  def finished_activities
    project_question_ids = completion_responses.select(:"project_questions.id")

    project_activities.joins(:project_questions)
      .where(project_questions: { id: project_question_ids })
      .distinct
  end

  def completion_responses
    newest_responses.joins(project_question: { question: :completion_question })
      .where(response_value_column.eq(completion_value_column))
  end

  def newest_responses
    user.responses.newest_per_project_question
  end

  def user
    viewpoint.user
  end

  def project_activities
    project.project_activities
  end

  def response_value_column
    Response.arel_table[:value]
  end

  def completion_value_column
    CompletionQuestion.arel_table[:completion_value]
  end
end
