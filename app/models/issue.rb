class Issue < ApplicationRecord
  SUBJECT_TYPES = %w[Project ProjectActivity ProjectQuestion].freeze

  belongs_to :subject, polymorphic: true
  belongs_to :user
  has_one :resolution

  has_many_attached :photos

  validates :subject_type, inclusion: { in: SUBJECT_TYPES }
  validates :description, presence: true
  validates :critical, inclusion: { in: [true, false] }
end
