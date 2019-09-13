class Project < ApplicationRecord
  belongs_to :project_type
  has_many :project_activities

  scope :visible, -> { Viewpoint.current.scope(self) }

  validates :name, presence: true
end
