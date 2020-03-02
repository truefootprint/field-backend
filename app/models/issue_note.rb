class IssueNote < ApplicationRecord
  belongs_to :issue
  belongs_to :user

  has_many_attached :photos, dependent: :destroy

  validate :either_text_photos_or_resolved_present

  after_initialize do
    self.photos_json = "[]" if photos_json.blank?
  end

  def supports_photos?
    true
  end

  def photo_references
    PhotoReference.parse_json_array(photos_json)
  end

  private

  def either_text_photos_or_resolved_present
    return if text.present?
    return if photo_references.present?
    return if resolved

    errors.add(:base, "must include either text, photos json or be resolved")
  end
end
