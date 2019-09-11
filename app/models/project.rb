class Project < ApplicationRecord
  belongs_to :project_type

  has_many :project_activities

  validates :name, presence: true
end
