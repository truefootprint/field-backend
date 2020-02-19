class Resolution < ApplicationRecord
  SUBJECT_TYPES = %w[Issue].freeze

  belongs_to :issue
  belongs_to :user

  has_many :versioned_contents, as: :subject, inverse_of: :subject

  validates :issue, uniqueness: true
  validates :versioned_contents, presence: true

  cattr_accessor :factory_bot

  def subject_id=(id)
    self.issue_id = id
  end

  def subject_type=(type)
    raise ArgumentError unless SUBJECT_TYPES.include?(type)
  end

  def created_at_issue_content_version=(_)
    # TODO
  end
end
