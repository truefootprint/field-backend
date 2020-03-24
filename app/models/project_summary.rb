class ProjectSummary < ApplicationRecord
  translates :text

  belongs_to :project

  validates :project, uniqueness: true
  validates :text, presence: true
end
