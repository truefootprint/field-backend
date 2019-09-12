class AttendanceEvent
  def self.fire(**params)
    new(**params).process
  end

  attr_accessor :response, :follow_on_activity

  def initialize(response:, follow_on_activity_id:)
    self.response = response
    self.follow_on_activity = Activity.find(follow_on_activity_id)
  end

  def process
    project_activity = create_project_activity

    create_project_questions(project_activity)
  end

  private

  def create_project_activity
    ProjectActivity.create!(
      project: response.project,
      activity: follow_on_activity,
      state: "not_started",
      order: order_specified_by_project_type,
    )
  end

  def create_project_questions(project_activity)
    follow_on_activity.default_questions.each do |default|
      ProjectQuestion.create!(
        subject: project_activity,
        question: default.question,
        order: default.order,
      )
    end
  end

  def order_specified_by_project_type
    DefaultActivity.find_by!(
      project_type: response.project_type,
      activity: follow_on_activity,
    ).order
  end
end
