class ResponseTrigger < ApplicationRecord
  belongs_to :question

  validates :value, presence: true
  validates :event_name, presence: true

  scope :triggered_by, -> (response) do
    where(question: response.question, value: response.value)
  end

  def self.fire_events(response)
    triggered_by(response).each { |trigger| trigger.fire_event(response) }
  end

  def fire_event(response)
    event_name.constantize.fire(response: response, **event_params)
  end

  def event_params
    super.deep_symbolize_keys
  end
end
