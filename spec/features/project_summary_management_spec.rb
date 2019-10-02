RSpec.describe "Project summary management" do
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

  let(:another_project_id) do
    post "/projects", auth.merge(programme_id: programme_id, project_type_id: project_type_id, name: "Project")
    parsed_json.fetch(:id)
  end

  scenario "provides API endpoints to manage project activities" do
    get "/project_summaries", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []

    post "/project_summaries", auth.merge(project_id: project_id, text: "Summary text")
    expect(response.status).to eq(201)

    post "/project_summaries", auth.merge(project_id: project_id)
    expect(response.status).to eq(422)
    expect(error_messages).to include("Text can't be blank")

    post "/project_summaries", auth.merge(project_id: another_project_id, text: "Another text")
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    get "/project_summaries", auth
    expect(parsed_json.size).to eq(2)

    get "/project_summaries", auth.merge(text: "Another text")
    expect(parsed_json.size).to eq(1)

    get "/project_summaries/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(text: "Another text")

    delete "/project_summaries/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(text: "Another text")

    get "/project_summaries/#{id}", auth
    expect(response.status).to eq(404)

    delete "/project_summaries/#{id}", auth
    expect(response.status).to eq(404)

    get "/project_summaries", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(text: "Summary text"),
    ]

    id = parsed_json.first.fetch(:id)

    put "/project_summaries/#{id}", auth.merge(text: "New text")
    expect(response.status).to eq(200)
    expect(parsed_json).to include(text: "New text")

    put "/project_summaries/#{id}", auth.merge(text: " ")
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Text can't be blank"]
  end
end