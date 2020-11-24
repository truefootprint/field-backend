class ProjectActivity < ApplicationRecord
  belongs_to :project
  belongs_to :activity

  has_many :project_questions
  has_many :source_materials, class_name: :SourceMaterial, as: :subject, inverse_of: :subject
  has_many :issues, class_name: :Issue, as: :subject, inverse_of: :subject

  delegate :name, to: :activity

  scope :visible, -> { visible_to(Viewpoint.current) }
  scope :visible_to, -> (viewpoint) { viewpoint.scope(self) }
  #scope :multi_choice_questions, -> {  }

  scope :with_visible_project_questions, -> (viewpoint) {
    joins(:project_questions).merge(ProjectQuestion.visible_to(viewpoint))
  }

  validates :order, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def self.project_questions
    ProjectQuestion.where(project_activity_id: select(:id)).order(:question_id)
  end

  def multi_choice_project_questions
    project_questions.joins("INNER JOIN questions ON questions.id = project_questions.question_id")
    .where("questions.type = 'MultiChoiceQuestion'")
  end
end
