class ProjectQuestion < ApplicationRecord
  belongs_to :project_activity
  belongs_to :question
  has_many :responses
  has_one :completion_question, through: :question

  delegate :project, to: :project_activity
  delegate :project_type, to: :project
  delegate :text, to: :question

  scope :visible, -> { visible_to(Viewpoint.current) }
  scope :visible_to, -> (viewpoint) {
    viewpoint.scope(self).or(where(question_id: Question.visible_to(viewpoint)))
  }

  validates :order, presence: true

  def self.topics
    Topic.where(id: joins(:question).select(:"questions.topic_id"))
  end

  def self.completion_questions
    scope = includes(:completion_question).where.not(completion_questions: { id: nil })
    CompletionQuestion.where(id: scope.select(:"completion_questions.id"))
  end
end
