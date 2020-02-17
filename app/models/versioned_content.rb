class VersionedContent < ApplicationRecord
  SUBJECT_TYPES = %w[Issue Resolution].freeze

  belongs_to :subject, polymorphic: true
  belongs_to :user

  has_ancestry

  validates :content, presence: true
  validates :subject_type, inclusion: { in: SUBJECT_TYPES }

  validate :subject do
    subject_is_the_same_as(ancestors, "ancestors")
    subject_is_the_same_as(descendants, "descendents") unless new_record?
  end

  after_initialize do
    self.photos = "[]" if photos.blank?
  end

  def self.latest
    order(created_at: :desc).first
  end

  private

  def subject_is_the_same_as(scope, name)
    subjects = scope.pluck(:subject_type, :subject_id)
    return if subjects.all? { |s| s == [subject_type, subject_id] }

    errors.add(:subject, "must be the same as its #{name}")
  end
end
