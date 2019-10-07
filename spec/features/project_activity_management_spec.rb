RSpec.describe "Project activity management" do
  let!(:user) { FactoryBot.create(:user, name: "Test") }
  let!(:role) { FactoryBot.create(:role, name: "Admin") }

  let(:auth) { { user_name: "Test", role_name: "Admin" } }

  let(:programme_id) do
    post "/programmes", name: "Programme", description: "Description"
    parsed_json.fetch(:id)
  end

  let(:project_type_id) do
    post "/project_types", name: "Project Type"
    parsed_json.fetch(:id)
  end

  let(:project_id) do
    post "/projects", programme_id: programme_id, project_type_id: project_type_id, name: "Project"
    parsed_json.fetch(:id)
  end

  let(:activity_id) do
    post "/activities", name: "Activity"
    parsed_json.fetch(:id)
  end

  scenario "provides API endpoints to manage project activities" do
    get "/project_activities", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []
    expect(response.headers.fetch("X-Total-Count")).to eq(0)

    post "/project_activities", project_id: project_id, activity_id: activity_id, order: 1
    expect(response.status).to eq(201)

    post "/project_activities", project_id: project_id, activity_id: activity_id
    expect(response.status).to eq(422)
    expect(error_messages).to include("Order can't be blank")

    post "/project_activities", project_id: project_id, activity_id: activity_id, order: 2
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    get "/project_activities", auth
    expect(parsed_json.size).to eq(2)

    get "/project_activities", order: 2
    expect(parsed_json.size).to eq(1)

    get "/project_activities/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(order: 2)

    delete "/project_activities/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(order: 2)

    get "/project_activities/#{id}", auth
    expect(response.status).to eq(404)

    delete "/project_activities/#{id}", auth
    expect(response.status).to eq(404)

    get "/project_activities", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(order: 1),
    ]

    id = parsed_json.first.fetch(:id)

    put "/project_activities/#{id}", order: 3
    expect(response.status).to eq(200)
    expect(parsed_json).to include(order: 3)

    put "/project_activities/#{id}", order: -1
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Order must be greater than 0"]
  end
end
