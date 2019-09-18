class Project < ApplicationRecord
  belongs_to :project_type
  has_many :project_activities

  has_many :project_questions, class_name: :ProjectQuestion, as: :subject, inverse_of: :subject

  scope :visible, -> {
    Viewpoint.current.scope(self).or(where(project_type_id: ProjectType.visible))
  }

  validates :name, presence: true
end
