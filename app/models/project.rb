class Project < ApplicationRecord
  translates :name

  belongs_to :programme
  belongs_to :project_type
  has_many :project_activities

  has_many :source_materials, class_name: :SourceMaterial, as: :subject, inverse_of: :subject
  has_many :issues, class_name: :Issue, as: :subject, inverse_of: :subject

  has_one :project_summary

  scope :visible, -> { visible_to(Viewpoint.current) }
  scope :visible_to, -> (viewpoint) {
    viewpoint.scope(self).or(where(project_type_id: ProjectType.visible_to(viewpoint)))
  }

  validates :name, presence: true
end
