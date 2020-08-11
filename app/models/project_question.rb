class ProjectQuestion < ApplicationRecord
  belongs_to :project_activity
  belongs_to :question

  has_one :completion_question, through: :question
  has_one :expected_value

  has_many :responses
  has_many :issues, class_name: :Issue, as: :subject, inverse_of: :subject

  delegate :project, to: :project_activity
  delegate :project_type, to: :project
  delegate :text, :type, :data_type, to: :question

  scope :multi_choice_project_questions, -> { joins("INNER JOIN questions ON questions.id = project_questions.question_id").where("questions.type = 'MultiChoiceQuestion'") }
  scope :visible, -> { visible_to(Viewpoint.current) }
  scope :visible_to, -> (viewpoint) { viewpoint.scope(self) }

  validates :order, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def self.topics
    Topic.where(id: joins(:question).select(:"questions.topic_id"))
  end

 # def
  #ProjectQuestion.joins("INNER JOIN questions ON questions.id = project_questions.question_id").where("questions.type = 'MultiChoiceQuestion'").where(project_activity: [35, 37]).count


  def self.completion_questions
    scope = includes(:completion_question).where.not(completion_questions: { id: nil })
    CompletionQuestion.where(id: scope.select(:"completion_questions.id"))
  end

  def all_multi_choice_responses(startDate = nil, endDate = nil)
    if (startDate && endDate)
      condition = responses.where('created_at BETWEEN ? AND ?', startDate, endDate)
    else
      condition = responses
    end
    condition.map{ |r| JSON.parse(r.value) }.flatten.sort
  end

  def multi_choice_project_question_graph(startDate = nil, endDate = nil )
    array_of_hashes = question.multi_choice_options.map{ |option| {option_id: option.id, option_text: option.text, count: 0} }
    array_of_hashes.each { |h| h[:count] = all_multi_choice_responses(startDate, endDate).count(h[:option_id]) }
    {
      labels: array_of_hashes.sort_by! { |k| k["option_id"]}.map {|o| o[:option_text] },
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
          data: array_of_hashes.sort_by! { |k| k["option_id"]}.map {|o| o[:count] }
        }
      ]
    }
  end

  def responses_count_project_question_graph(startDate = nil, endDate = nil)
    if (startDate && endDate)
      condition = responses.where('created_at BETWEEN ? AND ?', startDate, endDate)
    else
      condition = responses
    end
    [{ option_id: self.id, option_text: "Responses", count: condition.count }]
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


  def multi_choice_options_ids
    question.multi_choice_options.map(&:id)
  end
end
