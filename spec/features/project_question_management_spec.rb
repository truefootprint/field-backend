RSpec.describe "Project question management" do
  let!(:user) { FactoryBot.create(:user, name: "Test") }
  let!(:role) { FactoryBot.create(:role, name: "Admin") }

  let(:auth) { { user_name: "Test", role_name: "Admin" } }

  let(:programme_id) do
    post "/programmes", auth.merge(name: "Programme name", description: "Description")
    parsed_json.fetch(:id)
  end

  let(:project_type_id) do
    post "/project_types", auth.merge(name: "Project Type")
    parsed_json.fetch(:id)
  end

  let(:project_id) do
    post "/projects", auth.merge(programme_id: programme_id, project_type_id: project_type_id, name: "Project")
    parsed_json.fetch(:id)
  end

  let(:activity_id) do
    post "/activities", auth.merge(name: "Activity name"); parsed_json.fetch(:id)
  end

  let(:project_activity_id) do
    post "/project_activities", auth.merge(project_id: project_id, activity_id: activity_id, order: 1)
    parsed_json.fetch(:id)
  end

  let(:topic_id) do
    post "/topics", auth.merge(name: "Topic name"); parsed_json.fetch(:id)
  end

  let(:question_id) do
    post "/questions", auth.merge(
      topic_id: topic_id,
      type: "FreeTextQuestion",
      data_type: "string",
      text: "Question text",
      expected_length: 10,
    )
    parsed_json.fetch(:id)
  end

  scenario "provides API endpoints to manage project questions" do
    get "/project_questions", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []

    post "/project_questions", auth.merge(
      project_activity_id: project_activity_id,
      question_id: question_id,
      order: 1,
    )
    expect(response.status).to eq(201)

    post "/project_questions", auth.merge(
      project_activity_id: project_activity_id,
      question_id: question_id,
    )
    expect(response.status).to eq(422)
    expect(error_messages).to include("Order can't be blank")

    post "/project_questions", auth.merge(
      project_activity_id: project_activity_id,
      question_id: question_id,
      order: 2,
    )
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    get "/project_questions", auth
    expect(parsed_json.size).to eq(2)

    get "/project_questions", auth.merge(order: 2)
    expect(parsed_json.size).to eq(1)

    get "/project_questions/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(order: 2)

    delete "/project_questions/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(order: 2)

    get "/project_questions/#{id}", auth
    expect(response.status).to eq(404)

    delete "/project_questions/#{id}", auth
    expect(response.status).to eq(404)

    get "/project_questions", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(order: 1),
    ]

    id = parsed_json.first.fetch(:id)

    put "/project_questions/#{id}", auth.merge(order: 3)
    expect(response.status).to eq(200)
    expect(parsed_json).to include(order: 3)

    put "/project_questions/#{id}", auth.merge(order: -1)
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Order must be greater than 0"]
  end
end
