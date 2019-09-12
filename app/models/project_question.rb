class ProjectQuestion < ApplicationRecord
  belongs_to :subject, polymorphic: true
  belongs_to :question

  validates :order, presence: true

  def project
    case subject_type
    when "Project"
      subject
    when "ProjectActivity"
      subject.project
    end
  end
end
