class ProjectSummary < ApplicationRecord
  belongs_to :project

  validates :project, uniqueness: true
  validates :text, presence: true
end
