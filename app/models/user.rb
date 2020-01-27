class User < ApplicationRecord
  attr_encrypted :phone_number, key: ENV.fetch("KEY")

  has_many :user_roles
  has_many :responses

  validates :name, presence: true
  validates :phone_number, presence: true, numericality: true

  validates :country_code, presence: true
  validate :country_code_starts_with_plus

  private

  def country_code_starts_with_plus
    return if country_code&.starts_with?("+")
    errors.add(:country_code, "must start with a plus (+) character")
  end
end
