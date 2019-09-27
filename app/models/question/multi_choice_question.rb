class MultiChoiceQuestion < Question
  validates :multiple_answers, inclusion: { in: [true, false] }
end
