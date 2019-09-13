class Activity < ApplicationRecord
  validates :name, presence: true

  scope :visible, -> { Viewpoint.current.scope(self) }

  def default_questions
    DefaultQuestion.where(activity: self).includes(:question)
  end
end
