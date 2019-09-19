class Question < ApplicationRecord
  belongs_to :topic
  has_one :completion_question

  scope :visible, -> {
    Viewpoint.current.scope(self).or(where(topic_id: Topic.visible))
  }

  validates :text, presence: true, uniqueness: { scope: :topic_id }
end
