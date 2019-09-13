class ProjectQuestionPresenter
  def self.present(project_questions)
    project_questions.order(:order).includes(:question).map { |pq| new(pq).as_json }
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
end
