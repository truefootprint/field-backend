class DefaultActivity < ApplicationRecord
  belongs_to :project_type
  belongs_to :activity

  validates :order, presence: true
end
