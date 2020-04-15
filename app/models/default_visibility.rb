class DefaultVisibility < ApplicationRecord
  SUBJECT_TYPES = %w[ProjectType Activity Question].freeze

  belongs_to :subject, polymorphic: true
  belongs_to :role

  validates :subject_id, uniqueness: { scope: %i[subject_type role] }
  validates :subject_type, inclusion: { in: SUBJECT_TYPES }
end
