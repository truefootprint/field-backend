class ProjectActivity < ApplicationRecord
  belongs_to :project
  belongs_to :activity

  validates :state, inclusion: { in: %w[not_started in_progress finished] }
  validates :order, presence: true
end
