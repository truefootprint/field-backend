class DefaultActivity < ApplicationRecord
  belongs_to :project_type
  belongs_to :activity

  validates :order, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
