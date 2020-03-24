class Topic < ApplicationRecord
  translates :name

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :visible, -> { visible_to(Viewpoint.current) }
  scope :visible_to, -> (viewpoint) { viewpoint.scope(self) }
end
