class Role < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def admin?
    name == "admin"
  end
end
