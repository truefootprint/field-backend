class MultiChoiceQuestion < Question
  has_many :multi_choice_options, foreign_key: :question_id

  validates :multiple_answers, inclusion: { in: [true, false] }
end
