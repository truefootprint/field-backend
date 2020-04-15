class Question < ApplicationRecord
  TYPES = %w[FreeTextQuestion MultiChoiceQuestion PhotoUploadQuestion].freeze
  DATA_TYPES = %w[boolean number photo string].freeze

  translates :text

  belongs_to :topic
  belongs_to :unit, optional: true
  has_one :completion_question

  validates :text, presence: true, uniqueness: { scope: :topic_id }
  validates :type, presence: true
  validates :type, inclusion: { in: TYPES }
  validates :data_type, inclusion: { in: DATA_TYPES }
end
