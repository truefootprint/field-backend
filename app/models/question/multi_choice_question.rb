class MultiChoiceQuestion < Question
  has_many :multi_choice_options

  validates :multiple_answers, inclusion: { in: [true, false] }
end
