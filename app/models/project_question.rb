class ProjectQuestion < ApplicationRecord
  belongs_to :subject, polymorphic: true
  belongs_to :question
  has_many :responses
  has_one :completion_question, through: :question

  delegate :project_type, to: :project
  delegate :text, to: :question

  scope :visible, -> {
    Viewpoint.current.scope(self).or(where(question_id: Question.visible))
  }

  validates :order, presence: true

  def self.completion_questions
    scope = includes(:completion_question).where.not(completion_questions: { id: nil })
    CompletionQuestion.where(id: scope.pluck(:"completion_questions.id"))
  end

  def project
    case subject_type
    when "Project"
      subject
    when "ProjectActivity"
      subject.project
    end
  end
end
