class Topic < ApplicationRecord
  validates :name, presence: true

  scope :visible, -> { Viewpoint.current.scope(self) }
end
