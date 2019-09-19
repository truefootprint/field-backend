class Topic < ApplicationRecord
  validates :name, presence: true

  scope :visible, -> { visible_to(Viewpoint.current) }
  scope :visible_to, -> (viewpoint) { viewpoint.scope(self) }
end
