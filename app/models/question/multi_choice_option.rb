class MultiChoiceOption < ApplicationRecord
  belongs_to :question, class_name: :MultiChoiceQuestion

  validates :text, presence: true, uniqueness: { scope: :question_id }
  validates :order, presence: true
end
