class UserInterfaceText < ApplicationRecord
  self.table_name = :user_interface_text

  translates :value

  validates :key, presence: true, uniqueness: { case_sensitive: false }
  validates :value, presence: true
end
