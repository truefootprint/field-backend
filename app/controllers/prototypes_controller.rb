class PrototypesController < ApplicationController
  def topic_and_question_listing
    project = Project.visible.first
    project_activities = project.project_activities.order(:order)

    user = User.find_by!(name: params.fetch(:name))
    role = Role.find_by!(name: params.fetch(:role))

    project_activity = project_activities.detect do |pa|
      project_questions = pa.project_questions

      next unless project_questions.any? do |pq|
        Visibility.find_by(subject: pq.question, visible_to: role)
      end

      responses = project_questions.flat_map { |pq| pq.responses.where(user: user) }

      if responses.empty?
        true
      else
        pa.state == "in_progress"
      end
    end
    project_activity = project_activities.where(state: "not_started").first unless project_activity

    project_questions = project_activity .project_questions

    project_questions = project_questions.select do |project_question|
      Visibility.find_by(subject: project_question.question, visible_to: role)
    end
    project_questions = ProjectQuestion.where(id: project_questions.map(&:id))

    chunks = project_questions
      .order(:order)
      .includes(question: :topic)
      .chunk { |pq| pq.question.topic }

    presented = chunks.map do |topic, project_questions|
      inner = project_questions.map do |pq|
        {
          id: pq.id,
          text: pq.question.text,
          order: pq.order,
        }
      end

      {
        topic_name: topic.name,
        project_questions: inner,
      }
    end

    render json: presented
  end

  def average_water_pump_depth
    project_type = ProjectType.find_by!(name: "Water pump")

    activity = Activity.find_by!(name: "Digging the hole")
    question = Question.find_by!(text: "Depth in meters")

    project_activities = ProjectActivity.where(activity: activity)
    project_questions = ProjectQuestion.where(subject: project_activities, question: question)

    average = Response.where(project_question: project_questions).select("avg(cast(value as float))")

    render json: average
  end

  def mark_workshop_as_finished
    project = Project.find(3)
    workshop = project.project_activities.first

    trigger_question = workshop.project_questions.detect do |pq|
      pq.question.text == "Is the workshop finished?"
    end

    user = User.find_by_name!(params.fetch(:name))

    params = { project_question: trigger_question, user: user, value: "yes" }

    Response.find_by(params)&.destroy
    response = Response.create!(params)

    ResponseTrigger.fire_events(response)

    render json: "ok"
  end
end
