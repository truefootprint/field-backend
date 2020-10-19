class Programme < ApplicationRecord
  translates :name, :description

  has_many :projects

  has_many :project_activities, -> { distinct }, through: :projects
  has_many :project_questions, -> { distinct }, through: :project_activities

  validates :name, presence: true
  validates :description, presence: true

  def questions
  	ids = project_questions.order(:question_id)
  	.joins("INNER JOIN questions ON questions.id = project_questions.question_id")
    .map(&:question_id)
    .uniq
    Question.where(id: ids).order(:id)
  end

  def photos
    a = []
    project_questions.select {|pq| pq.type == "PhotoUploadQuestion" }.each do |project_question|
      project_question.responses.each do |response|
        response.photos.map do |photo|
          a << {
                 text: "User Id: #{response.user.id}, Response Id: #{response.id}, Programme: #{self.name}, Project: #{project_question.project.name}, Activity: #{project_question.project_activity.name}",
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
end
