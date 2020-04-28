class Role < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

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
