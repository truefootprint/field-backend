RSpec.describe "Project management" do
  let!(:user) { FactoryBot.create(:user, name: "Test") }
  let!(:role) { FactoryBot.create(:role, name: "Admin") }

  let(:auth) { { user_name: "Test", role_name: "Admin" } }

  let(:programme_id) do
    post "/programmes", name: "Programme name", description: "Description"
    parsed_json.fetch(:id)
  end

  let(:project_type_id) do
    post "/project_types", name: "Project type name"
    parsed_json.fetch(:id)
  end

  scenario "provides API endpoints to manage projects" do
    get "/projects", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []
    expect(response.headers.fetch("X-Total-Count")).to eq(0)

    post "/projects", auth.merge(
      programme_id: programme_id,
      project_type_id: project_type_id,
      name: "My project",
    )
    expect(response.status).to eq(201)

    post "/projects", programme_id: programme_id, project_type_id: project_type_id
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Name can't be blank"]

    post "/projects", auth.merge(
      programme_id: programme_id,
      project_type_id: project_type_id,
      name: "Another project",
    )
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    get "/projects", auth
    expect(parsed_json.size).to eq(2)

    get "/projects", name: "My project"
    expect(parsed_json.size).to eq(1)

    get "/projects/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "Another project")

    delete "/projects/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "Another project")

    get "/projects/#{id}", auth
    expect(response.status).to eq(404)

    delete "/projects/#{id}", auth
    expect(response.status).to eq(404)

    get "/projects", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(name: "My project"),
    ]

    id = parsed_json.first.fetch(:id)

    put "/projects/#{id}", name: "New name"
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "New name")

    put "/projects/#{id}", name: " "
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Name can't be blank"]
  end
end
