class ProjectRole < ApplicationRecord
  belongs_to :project
  belongs_to :role

  validates :role, uniqueness: { scope: :project }
  validates :order, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
