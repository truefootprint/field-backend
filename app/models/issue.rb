class Issue < ApplicationRecord
  SUBJECT_TYPES = %w[Project ProjectActivity ProjectQuestion].freeze

  belongs_to :subject, polymorphic: true
  belongs_to :user

  has_one :resolution
  has_many :versioned_contents, as: :subject, inverse_of: :subject
  has_many_attached :photos, dependent: :destroy

  validates :subject_type, inclusion: { in: SUBJECT_TYPES }
  validates :versioned_contents, presence: true, unless: -> { factory_bot }
  validates :critical, inclusion: { in: [true, false] }

  cattr_accessor :factory_bot
end
