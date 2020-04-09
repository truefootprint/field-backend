class UserInterfaceText < ApplicationRecord
  self.table_name = :user_interface_text

  translates :value

  validates :key, presence: true, uniqueness: { case_sensitive: false }
  validates :value, presence: true
  validates :pre_login, inclusion: { in: [true, false] }

  def self.locales
    select("distinct jsonb_object_keys(value) as locale").map(&:locale)
  end
end
