class ProjectQuestion < ApplicationRecord
  belongs_to :subject, polymorphic: true
  belongs_to :question
  has_many :responses

  delegate :project_type, to: :project
  delegate :text, to: :question

  scope :visible, -> {
    Viewpoint.current.scope(self).or(where(question_id: Question.visible))
  }

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
