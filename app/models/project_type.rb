class ProjectType < ApplicationRecord
  has_many :projects

  scope :visible, -> { Viewpoint.current.scope(self) }

  validates :name, presence: true
end
