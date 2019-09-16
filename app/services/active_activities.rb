module ActiveActivities
  def self.for(user)
    project = Project.visible.first
    scope = project.project_activities.order(:order)

    project_activities = scope.select do |pa|
      project_questions = pa.project_questions.visible
      next if project_questions.empty?

      responses = project_questions.flat_map { |pq| pq.responses.where(user: user) }

      if responses.empty?
        true
      else
        pa.state == "in_progress"
      end
    end

    if project_activities.empty?
      scope.where(state: "not_started")
    else
      project_activities
    end
  end
end
