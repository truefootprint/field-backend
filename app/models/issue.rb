class Issue < ApplicationRecord
  SUBJECT_TYPES = %w[Project ProjectActivity ProjectQuestion].freeze

  belongs_to :subject, polymorphic: true
  belongs_to :user

  has_many :resolutions
  has_many :issue_notes

  validates :subject_type, inclusion: { in: SUBJECT_TYPES }
  validates :critical, inclusion: { in: [true, false] }
end
