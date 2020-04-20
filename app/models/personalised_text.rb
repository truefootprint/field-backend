class PersonalisedText < ApplicationRecord
  self.table_name = :personalised_text

  belongs_to :project_role
  belongs_to :user_interface_text

  translates :value

  validates :user_interface_text, uniqueness: { scope: :project_role }
  validates :value, presence: true

  def self.locales
    select("distinct jsonb_object_keys(value) as locale").map(&:locale)
  end
end
