class Resolution < ApplicationRecord
  SUBJECT_TYPES = %w[Issue].freeze

  belongs_to :issue
  belongs_to :user
  belongs_to :created_at_issue_content_version, class_name: :VersionedContent

  has_many :versioned_contents, as: :subject, inverse_of: :subject

  validates :versioned_contents, presence: true
  validate :created_at_issue_content_version, :points_to_the_same_issue

  cattr_accessor :factory_bot

  def subject_id=(id)
    self.issue_id = id
  end

  def subject_type=(type)
    raise ArgumentError unless SUBJECT_TYPES.include?(type)
  end

  private

  def points_to_the_same_issue
    version = created_at_issue_content_version
    return if version&.subject_type == "Issue" && version&.subject_id == issue_id

    message = "must point to the resolution's issue"
    errors.add(:created_at_issue_content_version_id, message)
  end
end
