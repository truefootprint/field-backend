class Issue < ApplicationRecord
  SUBJECT_TYPES = %w[Project ProjectActivity ProjectQuestion].freeze

  belongs_to :subject, polymorphic: true
  belongs_to :user

  has_many :resolutions
  has_many :notes, class_name: :IssueNote

  validates :subject_type, inclusion: { in: SUBJECT_TYPES }
  validates :notes, presence: true, unless: -> { factory_bot }
  validates :critical, inclusion: { in: [true, false] }

  cattr_accessor :factory_bot
end
