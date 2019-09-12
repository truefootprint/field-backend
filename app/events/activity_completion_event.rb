class ActivityCompletionEvent
  def self.fire(**params)
    new(**params).process
  end

  attr_accessor :response

  def initialize(response:)
    self.response = response
  end

  def process
    project_activity = response.project_question.subject
    return unless project_activity.is_a?(ProjectActivity)

    project_activity.update!(state: "finished")
  end
end
