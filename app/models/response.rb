class Response < ApplicationRecord
  belongs_to :project_question
  belongs_to :user

  validates :value, presence: true
end
