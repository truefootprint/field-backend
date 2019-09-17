class Project < ApplicationRecord
  belongs_to :project_type
  has_many :project_activities

  has_many :direct_project_questions, class_name: :ProjectQuestion, as: :subject, inverse_of: :subject
  has_many :project_activity_questions, through: :project_activities, source: :project_questions

  def all_project_questions
    ids = direct_project_questions.pluck(:id) + project_activity_questions.pluck(:id)
    ProjectQuestion.where(id: ids)
  end

  scope :visible, -> {
    Viewpoint.current.scope(self).or(where(project_type_id: ProjectType.visible))
  }

  scope :with_visible_project_activities, -> {
    joins(:project_activities).includes(:project_activities).merge(ProjectActivity.visible)
  }

  scope :with_visible_direct_project_questions, -> {
    joins(:direct_project_questions).includes(:direct_project_questions).merge(ProjectQuestion.visible)
  }

  scope :with_visible_project_activity_questions, -> {
    joins(project_activities: :project_questions).includes(project_activities: :project_questions)
      .merge(ProjectQuestion.visible)
  }

  validates :name, presence: true
end
