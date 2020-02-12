class ExifData < ApplicationRecord
  self.table_name = :exif_data_sets

  belongs_to :user

  validates :user, presence: true
  validates :filename, presence: true, uniqueness: true
  validates :data, presence: true

  validate :data_is_json

  private

  def data_is_json
    JSON.parse(data) if data.present?
  rescue JSON::ParserError
    errors.add(:data, "must be valid json")
  end
end
