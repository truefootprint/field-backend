class ApiToken < ApplicationRecord
  attr_encrypted :token, key: ENV.fetch("KEY")
  attr_encrypted :device_id, key: ENV.fetch("KEY")

  belongs_to :user

  before_validation :set_token

  validates :token, presence: true, length: { minimum: 10 }

  def just_used!
    self.times_used += 1
    self.touch(:last_used_at)
    self.save!
  end

  private

  def set_token
    self.token = SecureRandom.base64 unless token.present?
  end
end
