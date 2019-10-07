RSpec.describe "Project type management" do
  let!(:user) { FactoryBot.create(:user, name: "Test") }
  let!(:role) { FactoryBot.create(:role, name: "Admin") }

  let(:auth) { { user_name: "Test", role_name: "Admin" } }

  scenario "provides API endpoints to manage project types" do
    get "/project_types", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []
    expect(response.headers.fetch("X-Total-Count")).to eq(0)

    post "/project_types", name: "My project type"
    expect(response.status).to eq(201)

    post "/project_types", name: " "
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Name can't be blank"]

    post "/project_types", name: "Another project type"
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    get "/project_types", auth
    expect(parsed_json.size).to eq(2)

    get "/project_types", name: "My project type"
    expect(parsed_json.size).to eq(1)

    get "/project_types/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "Another project type")

    delete "/project_types/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "Another project type")

    get "/project_types/#{id}", auth
    expect(response.status).to eq(404)

    delete "/project_types/#{id}", auth
    expect(response.status).to eq(404)

    get "/project_types", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(name: "My project type"),
    ]

    id = parsed_json.first.fetch(:id)

    put "/project_types/#{id}", name: "New name"
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "New name")

    put "/project_types/#{id}", name: " "
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Name can't be blank"]
  end
end
