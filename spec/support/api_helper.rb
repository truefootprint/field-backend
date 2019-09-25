module ApiHelper
  include Rack::Test::Methods

  def app
    Rails.application
  end

  def response
    last_response
  end

  def parsed_json
    JSON.parse(response.body, symbolize_names: true)
  end

  def all_projects
    parsed_json.fetch(:projects)
  end

  def all_project_activities
    all_projects.flat_map { |p| p.fetch(:project_activities) }
  end

  def all_topics
    all_project_activities.flat_map { |pa| pa.dig(:project_questions, :by_topic) }
  end

  def all_project_questions
    all_topics.flat_map { |t| t.fetch(:project_questions) }
  end

  def find_project_question(id)
    all_project_questions.detect { |pq| pq.fetch(:id) == id }
  end
end
