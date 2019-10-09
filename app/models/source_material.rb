class SourceMaterial < ApplicationRecord
  SUBJECT_TYPES = %w[Project ProjectActivity]

  belongs_to :subject, polymorphic: true
  belongs_to :document

  validates :subject_type, inclusion: { in: SUBJECT_TYPES }
  validates :page, allow_nil: true, numericality: { only_integer: true, greater_than: 0 }
end
