class Issue < ApplicationRecord
  SUBJECT_TYPES = %w[Project ProjectActivity ProjectQuestion].freeze

  belongs_to :subject, polymorphic: true
  belongs_to :user

  has_many :notes, class_name: :IssueNote

  validates :uuid, presence: true, uuid: true
  validates :subject_type, inclusion: { in: SUBJECT_TYPES }
  validates :notes, presence: true, unless: -> { factory_bot }
  validates :critical, inclusion: { in: [true, false] }

  scope :resolved, -> { where(exists(IssueNote.resolved.where("issue_id = issues.id"))) }

  cattr_accessor :factory_bot

  def resolved?
    notes.resolved.exists?
  end
end
