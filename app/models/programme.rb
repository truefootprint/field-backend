class Programme < ApplicationRecord
  translates :name, :description

  has_many :projects

  has_many :project_activities, -> { distinct }, through: :projects
  has_many :project_questions, -> { distinct }, through: :project_activities

  validates :name, presence: true
  validates :description, presence: true

  def questions
  	ids = project_questions
  	.joins("INNER JOIN questions ON questions.id = project_questions.question_id")
    .map(&:question_id)
    .uniq
    Question.where(id: ids)
  end
end
