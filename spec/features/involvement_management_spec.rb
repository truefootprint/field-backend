RSpec.describe "Involvement management" do
  let!(:user) { FactoryBot.create(:user, name: "Test") }
  let!(:role) { FactoryBot.create(:role, name: "Admin") }

  let(:auth) { { user_name: "Test", role_name: "Admin" } }

  let(:programme_id) do
    post "/programmes", auth.merge(name: "Programme", description: "Description")
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
    post "/activities", auth.merge(name: "Activity")
    parsed_json.fetch(:id)
  end

  let(:project_activity_id) do
    post "/project_activities", auth.merge(project_id: project_id, activity_id: activity_id, order: 1)
    parsed_json.fetch(:id)
  end

  let(:user1_id) { post "/users", auth.merge(name: "User 1"); parsed_json.fetch(:id) }
  let(:user2_id) { post "/users", auth.merge(name: "User 2"); parsed_json.fetch(:id) }
  let(:user3_id) { post "/users", auth.merge(name: "User 3"); parsed_json.fetch(:id) }

  scenario "provides API endpoints to manage involvements" do
    get "/involvements", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []

    post "/involvements", auth.merge(project_activity_id: project_activity_id, user_id: user1_id)
    expect(response.status).to eq(201)

    post "/involvements", auth.merge(project_activity_id: project_activity_id)
    expect(response.status).to eq(422)
    expect(error_messages).to include("User must exist")

    post "/involvements", auth.merge(project_activity_id: project_activity_id, user_id: user2_id)
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    get "/involvements", auth
    expect(parsed_json.size).to eq(2)

    get "/involvements", auth.merge(user_id: user2_id)
    expect(parsed_json.size).to eq(1)

    get "/involvements/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(user_id: user2_id)

    delete "/involvements/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(user_id: user2_id)

    get "/involvements/#{id}", auth
    expect(response.status).to eq(404)

    delete "/involvements/#{id}", auth
    expect(response.status).to eq(404)

    get "/involvements", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(user_id: user1_id),
    ]

    id = parsed_json.first.fetch(:id)

    put "/involvements/#{id}", auth.merge(user_id: user3_id)
    expect(response.status).to eq(200)
    expect(parsed_json).to include(user_id: user3_id)

    put "/involvements/#{id}", auth.merge(user_id: 999)
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["User must exist"]
  end
end
