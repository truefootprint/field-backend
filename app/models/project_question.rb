class ProjectQuestion < ApplicationRecord
  belongs_to :project_activity
  belongs_to :question

  has_one :completion_question, through: :question
  has_one :expected_value

  has_many :responses
  has_many :issues, class_name: :Issue, as: :subject, inverse_of: :subject

  delegate :project, to: :project_activity
  delegate :project_type, to: :project
  delegate :text, :type, :data_type, to: :question

  scope :visible, -> { visible_to(Viewpoint.current) }
  scope :visible_to, -> (viewpoint) { viewpoint.scope(self) }

  validates :order, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def self.topics
    Topic.where(id: joins(:question).select(:"questions.topic_id"))
  end

  def self.completion_questions
    scope = includes(:completion_question).where.not(completion_questions: { id: nil })
    CompletionQuestion.where(id: scope.select(:"completion_questions.id"))
  end
end
