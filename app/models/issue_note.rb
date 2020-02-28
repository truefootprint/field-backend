class IssueNote < ApplicationRecord
  belongs_to :issue
  belongs_to :user

  has_many_attached :photos, dependent: :destroy

  validate :either_text_or_photos_json_present

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

  def either_text_or_photos_json_present
    return if text.present?
    return if photo_references.present?

    errors.add(:base, "must include either text or photos json")
  end
end
