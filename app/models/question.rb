class Question < ApplicationRecord
  belongs_to :topic
  has_one :completion_question

  scope :visible, -> { visible_to(Viewpoint.current) }
  scope :visible_to, -> (viewpoint) {
    viewpoint.scope(self).or(where(topic_id: Topic.visible_to(viewpoint)))
  }

  validates :text, presence: true, uniqueness: { scope: :topic_id }
  validates :type, presence: true
end
