class DefaultExpectedValue < ApplicationRecord
  belongs_to :question
  belongs_to :activity, optional: true

  validates :value, presence: true
end
