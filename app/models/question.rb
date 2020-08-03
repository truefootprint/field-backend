class Question < ApplicationRecord
  TYPES = %w[FreeTextQuestion MultiChoiceQuestion PhotoUploadQuestion].freeze
  DATA_TYPES = %w[boolean number photo string].freeze

  translates :text

  belongs_to :topic
  belongs_to :unit, optional: true
  has_one :completion_question

  validates :text, presence: true, uniqueness: { scope: :topic_id }
  validates :type, presence: true
  validates :type, inclusion: { in: TYPES }
  validates :data_type, inclusion: { in: DATA_TYPES }

  def responses(startDate = nil, endDate = nil)
    if (startDate && endDate)
      condition = Response.where('created_at BETWEEN ? AND ?', startDate, endDate)
                          .where(project_question_id: ProjectQuestion.where(question_id: self.id))
    else
      condition = Response.where(project_question_id: ProjectQuestion.where(question_id: self.id))
    end
    condition.map{ |r| JSON.parse(r.value) }.flatten.sort
  end

  def multi_choice_options_hash(startDate = nil, endDate = nil )
    array_of_hashes = multi_choice_options.map{ |option| {option_id: option.id, option_text: option.text, count: 0} }
    array_of_hashes.each { |h| h[:count] = responses(startDate, endDate).count(h[:option_id]) }
    array_of_hashes
  end
end
