class Question < ApplicationRecord
  belongs_to :topic

  validates :text, presence: true, uniqueness: { scope: :topic_id }
end
