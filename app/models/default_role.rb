class DefaultRole < ApplicationRecord
  belongs_to :project_type
  belongs_to :role

  validates :role, uniqueness: { scope: :project_type }
end
