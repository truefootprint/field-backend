class MultiChoiceOption < ApplicationRecord
  belongs_to :question, class_name: :MultiChoiceQuestion

  validates :text, presence: true, uniqueness: { scope: :question_id }
  validates :order, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
