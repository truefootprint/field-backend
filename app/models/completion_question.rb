class CompletionQuestion < ApplicationRecord
  belongs_to :question

  validates :completion_value, presence: true
end
