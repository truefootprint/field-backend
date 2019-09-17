class ProjectActivity < ApplicationRecord
  belongs_to :project
  belongs_to :activity
  has_many :project_questions, as: :subject, inverse_of: :subject

  delegate :name, to: :activity

  scope :visible, -> {
    Viewpoint.current.scope(self).or(where(activity_id: Activity.visible))
  }

  scope :with_visible_project_questions, -> {
    joins(:project_questions).merge(ProjectQuestion.visible)
  }

  validates :state, inclusion: { in: %w[not_started in_progress finished] }
  validates :order, presence: true
end
