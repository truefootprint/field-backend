class ExpectedValue < ApplicationRecord
  belongs_to :project_question

  validates :value, presence: true
end
