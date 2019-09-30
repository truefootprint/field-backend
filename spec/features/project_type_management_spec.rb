RSpec.describe "Project type management" do
  let!(:user) { FactoryBot.create(:user, name: "Test") }
  let!(:role) { FactoryBot.create(:role, name: "Admin") }

  let(:auth) { { user_name: "Test", role_name: "Admin" } }

  scenario "provides API endpoints to manage project types" do
    get "/project_types", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []

    post "/project_types", auth.merge(name: "My project type")
    expect(response.status).to eq(201)

    post "/project_types", auth.merge(name: " ")
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Name can't be blank"]

    post "/project_types", auth.merge(name: "Another project type")
    expect(response.status).to eq(201)

    get "/project_types", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(name: "My project type"),
      hash_including(name: "Another project type"),
    ]

    id = parsed_json.first.fetch(:id)

    get "/project_types/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "My project type")

    delete "/project_types/#{id}", auth
    expect(response.status).to eq(204)

    get "/project_types/#{id}", auth
    expect(response.status).to eq(404)

    delete "/project_types/#{id}", auth
    expect(response.status).to eq(404)

    get "/project_types", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(name: "Another project type"),
    ]

    id = parsed_json.first.fetch(:id)

    put "/project_types/#{id}", auth.merge(name: "New name")
    expect(response.status).to eq(204)

    get "/project_types/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "New name")

    put "/project_types/#{id}", auth.merge(name: " ")
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Name can't be blank"]
  end
end
