class ProjectRole < ApplicationRecord
  belongs_to :project
  belongs_to :role

  validates :role, uniqueness: { scope: :project }
end
