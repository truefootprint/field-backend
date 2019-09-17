class PrototypesController < ApplicationController
  def topic_and_question_listing
    project_activities = ActiveActivities.for(current_user)
    project_questions = project_activities.first.project_questions.visible

    render json: ProjectQuestionPresenter::ByTopic.present(project_questions)
  end

  def mark_workshop_as_finished
    project = Project.find(3)
    workshop = project.project_activities.first

    trigger_question = workshop.project_questions.detect do |pq|
      pq.question.text == "Is the workshop finished?"
    end

    params = { project_question: trigger_question, user: current_user, value: "yes" }

    Response.find_by(params)&.destroy
    response = Response.create!(params)

    ResponseTrigger.fire_events(response)

    render json: "ok"
  end
end
