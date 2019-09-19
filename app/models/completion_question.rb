class CompletionQuestion < ApplicationRecord
  belongs_to :question

  validates :question, uniqueness: true
  validates :completion_value, presence: true
end
