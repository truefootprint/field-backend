class Activity < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :visible, -> { visible_to(Viewpoint.current) }
  scope :visible_to, -> (viewpoint) { viewpoint.scope(self) }

  def default_questions
    DefaultQuestion.where(activity: self).includes(:question)
  end
end
