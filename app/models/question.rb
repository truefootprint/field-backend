class Question < ApplicationRecord
  belongs_to :topic

  scope :visible, -> { Viewpoint.current.scope(self) }

  validates :text, presence: true, uniqueness: { scope: :topic_id }
end
