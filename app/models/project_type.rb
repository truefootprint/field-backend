class ProjectType < ApplicationRecord
  has_many :projects

  scope :visible, -> { visible_to(Viewpoint.current) }
  scope :visible_to, -> (viewpoint) { viewpoint.scope(self) }

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
