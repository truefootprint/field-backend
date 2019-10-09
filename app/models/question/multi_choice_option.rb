class MultiChoiceOption < ApplicationRecord
  belongs_to :question, class_name: :MultiChoiceQuestion

  validate :belongs_to_multi_choice_question
  validates :text, presence: true, uniqueness: { scope: :question_id }
  validates :order, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def belongs_to_multi_choice_question
    question = Question.find_by(id: question_id)

    return if question.nil? || question.is_a?(MultiChoiceQuestion)
    errors.add(:base, "Can't belong to a #{question.class.name}")
  end
end
