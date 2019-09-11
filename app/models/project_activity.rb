class ProjectActivity < ApplicationRecord
  belongs_to :project
  belongs_to :activity

  has_many :project_questions, as: :subject, inverse_of: :subject

  validates :state, inclusion: { in: %w[not_started in_progress finished] }
  validates :order, presence: true
end
