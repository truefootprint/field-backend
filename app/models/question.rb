class Question < ApplicationRecord
  TYPES = %w[FreeTextQuestion MultiChoiceQuestion PhotoUploadQuestion].freeze
  DATA_TYPES = %w[boolean number photo string].freeze

  belongs_to :topic
  has_one :completion_question

  scope :visible, -> { visible_to(Viewpoint.current) }
  scope :visible_to, -> (viewpoint) {
    viewpoint.scope(self).or(where(topic_id: Topic.visible_to(viewpoint)))
  }

  validates :text, presence: true, uniqueness: { scope: :topic_id }
  validates :type, presence: true
  validates :type, inclusion: { in: TYPES }
  validates :data_type, inclusion: { in: DATA_TYPES }
end
