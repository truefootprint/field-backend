class MultiChoiceOption < ApplicationRecord
  translates :text

  belongs_to :question, class_name: :MultiChoiceQuestion

  has_one_attached :photo, dependent: :destroy

  validate :belongs_to_multi_choice_question
  validates :text, presence: true, uniqueness: { scope: :question_id }
  validates :order, presence: true, numericality: { only_integer: true, greater_than: 0 }

  before_save do
    if self.photo.attached?
      ext = '.' + self.photo.blob.filename.extension
      self.photo.blob.update(filename: photo.blob.filename.base + SecureRandom.uuid  + ext)
    end
  end

  def belongs_to_multi_choice_question
    question = Question.find_by(id: question_id)

    return if question.nil? || question.is_a?(MultiChoiceQuestion)
    errors.add(:base, "Can't belong to a #{question.class.name}")
  end

  
end
