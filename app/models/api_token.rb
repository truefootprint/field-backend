class ApiToken < ApplicationRecord
  attr_encrypted :token, key: ENV.fetch("KEY")
  attr_encrypted :device_id, key: ENV.fetch("KEY")

  blind_index :token
  blind_index :device_id

  belongs_to :user

  validates :token, presence: true, uniqueness: true, length: { minimum: 10 }

  def self.generate_for!(user)
    create!(user: user, token: SecureRandom.base64)
  end

  def just_used!
    self.times_used += 1
    self.touch(:last_used_at)
    self.save!
  end
end
