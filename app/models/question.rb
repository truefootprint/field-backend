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

  def responses(startDate = nil, endDate = nil, programme_project_questions)
    if (startDate && endDate)
      condition = Response.where('created_at BETWEEN ? AND ?', startDate, endDate)
                          .where(project_question_id: programme_project_questions.where(question_id: self.id).ids)
    else
      condition = Response.where(project_question_id: programme_project_questions.where(question_id: self.id).ids)
    end
    condition.map{ |r| JSON.parse(r.value) }.flatten.sort
  end

  def graph_responses(startDate = nil, endDate = nil, programme_project_questions)
    if (startDate && endDate)
      condition = Response.where('created_at BETWEEN ? AND ?', startDate, endDate)
                          .where(project_question_id: programme_project_questions.where(question_id: self.id).ids)
    else
      condition = Response.where(project_question_id: programme_project_questions.where(question_id: self.id).ids)
    end
    condition.order(updated_at: :desc).map {|response| {user_id: response.user_id, 
                                                                                response: response.value, 
                                                                                date: response.updated_at.strftime("%m %b %Y"), 
                                                                                project: response.project_question.project.name}}
  end

  def multi_choice_options_hash(startDate = nil, endDate = nil, programme_project_questions)
    array_of_hashes = multi_choice_options.map{ |option| {option_id: option.id, option_text: option.text, count: 0} }
    array_of_hashes.each { |h| h[:count] = responses(startDate, endDate, programme_project_questions).count(h[:option_id]) }
    {
      labels: array_of_hashes.sort_by! { |k| k[:option_id]}.map {|o| o[:option_text] },
      datasets: [
        {
          label: self.text,
          backgroundColor: 'rgba(255,99,132,0.2)',
          borderColor: 'rgba(255,99,132,1)',
          borderWidth: 1,
          borderWidth: 3,
          barPercentage: 0.45,
          hoverBackgroundColor: 'rgba(255,99,132,0.4)',
          hoverBorderColor: 'rgba(255,99,132,1)',
          data: array_of_hashes.sort_by! { |k| k[:option_id]}.map {|o| o[:count] }
        }
      ]
    }
  end

  def responses_count_question_graph(startDate = nil, endDate = nil, programme_project_questions)
    if (startDate && endDate)
      condition = Response.where('created_at BETWEEN ? AND ?', startDate, endDate)
                          .where(project_question_id: programme_project_questions.where(question_id: self.id).ids)
    else
      condition = Response.where(project_question_id: programme_project_questions.where(question_id: self.id).ids)
    end
    [{ option_id: self.id, option_text: "Number of responses", count: condition.count }]
    {
      labels: ["Responses"],
      datasets: [
        {
          label: "Number of responses",
          backgroundColor: 'rgba(255,99,132,0.2)',
          borderColor: 'rgba(255,99,132,1)',
          borderWidth: 3,
          barPercentage: 0.45,
          hoverBackgroundColor: 'rgba(255,99,132,0.4)',
          hoverBorderColor: 'rgba(255,99,132,1)',
          data: [condition.count]
        }
      ]
    }
  end
end
