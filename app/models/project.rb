class Project < ApplicationRecord
  translates :name

  belongs_to :programme
  belongs_to :project_type

  has_many :project_activities
  has_many :project_roles

  has_many :project_questions, through: :project_activities

  has_many :project_question_issues, through: :project_questions, source: :issues

  has_many :source_materials, class_name: :SourceMaterial, as: :subject, inverse_of: :subject
  has_many :issues, class_name: :Issue, as: :subject, inverse_of: :subject

  scope :visible, -> { visible_to(Viewpoint.current) }
  scope :visible_to, -> (viewpoint) { viewpoint.scope(self) }

  validates :name, presence: true

  def photo_urls
    a = []
    project_questions.select {|pq| pq.type == "PhotoUploadQuestion" }.each do |project_question|
      project_question.responses.each do |response|
        response.photos.map do |photo|
          a << Rails.application.routes.url_helpers.url_for(photo)
        end
      end
    end
    a
  end

  def issues_graph(startDate = nil, endDate = nil)
    project_issues = project_question_issues
    project_issues = project_issues.where('issues.created_at BETWEEN ? AND ?', startDate, endDate) if (startDate && endDate)
    [{ option_id: self.id, option_text: "Total Issues", count: project_issues.count },
     { option_id: self.id, option_text: "Resolved Issues", count: project_issues.resolved.count }]
  end
end

