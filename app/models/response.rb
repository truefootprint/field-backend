class Response < ApplicationRecord
  belongs_to :project_question
  belongs_to :user

  delegate :question, :project, :project_type, to: :project_question

  validates :value, presence: true
end
