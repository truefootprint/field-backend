class DefaultRole < ApplicationRecord
  belongs_to :project_type
  belongs_to :role

  validates :role, uniqueness: { scope: :project_type }
  validates :order, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
