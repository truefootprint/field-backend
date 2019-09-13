class ProjectQuestion < ApplicationRecord
  belongs_to :subject, polymorphic: true
  belongs_to :question
  has_many :responses

  delegate :project_type, to: :project

  validates :order, presence: true

  def project
    { "Project" => subject, "ProjectActivity" => subject.project }.fetch(subject_type)
  end
end
