class Project < ApplicationRecord
  belongs_to :project_type
  has_many :project_activities

  has_many :source_materials, class_name: :SourceMaterial, as: :subject, inverse_of: :subject

  scope :visible, -> { visible_to(Viewpoint.current) }
  scope :visible_to, -> (viewpoint) {
    viewpoint.scope(self).or(where(project_type_id: ProjectType.visible_to(viewpoint)))
  }

  validates :name, presence: true
end
