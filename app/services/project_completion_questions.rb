class ProjectCompletionQuestions
  def self.for(**params)
    new(**params).project_completion_questions
  end

  attr_accessor :viewpoint, :project

  def initialize(viewpoint:, project:)
    self.viewpoint = viewpoint
    self.project = project
  end

  def project_completion_questions
    project.project_activities
      .visible_to(viewpoint)
      .project_questions
      .visible_to(viewpoint)
      .joins(question: :completion_question)
  end
end
