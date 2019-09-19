module CurrentProjectActivity
  class << self
    def for(viewpoint, project)
      user = viewpoint.user
      project_activities = project.project_activities

      newest_responses = user.responses.newest_per_project_question

      completion_responses = newest_responses
        .joins(project_question: { question: :completion_question })
        .where(response_value.eq(completion_value))

      project_question_ids = completion_responses.pluck(:"project_questions.id")

      finished_activities = project_activities.joins(:project_questions)
        .where(project_questions: { id: project_question_ids })
        .distinct

      unfinished_activities = project_activities
        .where.not(id: finished_activities)

      unfinished_activities.visible_to(viewpoint)
        .with_visible_project_questions(viewpoint)
        .order(:order)
        .first
    end

    def response_value
      Response.arel_table[:value]
    end

    def completion_value
      CompletionQuestion.arel_table[:completion_value]
    end
  end
end
