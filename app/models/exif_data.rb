class ExifData < ApplicationRecord
  self.table_name = :exif_data_sets

  belongs_to :user

  has_many_attached :photos, dependent: :destroy

  validates :user, presence: true
  validates :filename, presence: true, uniqueness: true
  validates :data, presence: true

  validate :data_is_json

  def parsed_data
    @parsed_data ||= JSON.parse(data)
  end

  def supports_photos?
    true
  end

  def photo_references
    [PhotoReference.new(uri: filename, exif: parsed_data)]
  end

  private

  def data_is_json
    parsed_data if data.present?
  rescue JSON::ParserError
    errors.add(:data, "must be valid json")
  end
end
