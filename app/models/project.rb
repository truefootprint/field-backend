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

  def photos
    a = []
    project_questions.select {|pq| pq.type == "PhotoUploadQuestion" }.each do |project_question|
      project_question.responses.each do |response|
        response.photos.map do |photo|
          a << {
                 text: "User Id: #{response.user.id}, Response Id: #{response.id}, Programme: #{self.programme.name}, Project: #{self.name}, Activity: #{project_question.project_activity.name}",
                 src: Rails.application.routes.url_helpers.url_for(photo),
                 key: photo.id.to_s,
                 width: 4,
                 height: 3
               }
        end
      end
    end
    a
  end

  def issue_photos
    a = []
    project_questions.each do |project_question|
      project_question.issues.each do |issue|
        issue.notes.map do |note|
          note.photos.map do |photo|
            a << {
                   text: "Photo Id: #{photo.id}, User Id: #{note.user.id}, User name: #{note.user.name},\
                   Issue Note Id: #{note.id}, Project Question: #{project_question.text},\
                   Project Question Id: #{project_question.id},\
                   Activity: #{project_question.project_activity.name}",
                   src: Rails.application.routes.url_helpers.url_for(photo),
                   key: photo.id.to_s,
                   width: 4,
                   height: 3
                 }
          end
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
    {
      labels: ["Total Issues", "Resolved Issues"],
      datasets: [
        {
          label: 'Count',
          backgroundColor: 'rgba(255,99,132,0.2)',
          borderColor: 'rgba(255,99,132,1)',
          borderWidth: 3,
          barPercentage: 0.45,
          hoverBackgroundColor: 'rgba(255,99,132,0.4)',
          hoverBorderColor: 'rgba(255,99,132,1)',
          data: [project_issues.count, project_issues.resolved.count]
        }
      ]
    }
  end
end

