class Activity < ApplicationRecord
  validates :name, presence: true

  def default_questions
    DefaultQuestion.where(activity: self).includes(:question)
  end
end
