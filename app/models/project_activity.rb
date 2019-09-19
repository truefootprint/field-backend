class ProjectActivity < ApplicationRecord
  belongs_to :project
  belongs_to :activity
  has_many :project_questions, as: :subject, inverse_of: :subject

  delegate :name, to: :activity

  scope :visible, -> {
    Viewpoint.current.scope(self).or(where(activity_id: Activity.visible))
  }

  validates :order, presence: true
end
