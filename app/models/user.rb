class User < ApplicationRecord
  attr_encrypted :phone_number, key: ENV.fetch("KEY")
  blind_index :phone_number

  has_many :user_roles
  has_many :roles, through: :user_roles
  has_many :responses
  has_many :issues
  has_many :issue_notes
  has_many :exif_data_sets, class_name: :ExifData

  validates :name, presence: true
  validates :phone_number, presence: true, uniqueness: true, numericality: true

  validates :country_code, presence: true
  validate :country_code_starts_with_plus

  private

  def country_code_starts_with_plus
    return if country_code&.starts_with?("+")
    errors.add(:country_code, "must start with a plus (+) character")
  end
end
