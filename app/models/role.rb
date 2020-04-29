class Role < ApplicationRecord
  translates :display_name

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :display_name, presence: true

  def admin?
    name == "admin"
  end

  def unspecified?
    name == "unspecified"
  end

  def user_selectable?
    !admin? && !unspecified?
  end
end
