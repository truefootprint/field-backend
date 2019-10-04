RSpec.describe "Resolution management" do
  let!(:user) { FactoryBot.create(:user, name: "Test") }
  let!(:role) { FactoryBot.create(:role, name: "Admin") }

  let(:auth) { { user_name: "Test", role_name: "Admin" } }

  let(:programme_id) do
    post "/programmes", auth.merge(name: "Programme name", description: "Description")
    parsed_json.fetch(:id)
  end

  let(:issue_params) do
    { subject_type: "Programme", subject_id: programme_id, user_id: user_id, description: "Description" }
  end

  let(:issue1_id) { post "/issues", auth.merge(issue_params); parsed_json.fetch(:id) }
  let(:issue2_id) { post "/issues", auth.merge(issue_params); parsed_json.fetch(:id) }

  let(:user_id) { post "/users", auth.merge(name: "User 1"); parsed_json.fetch(:id) }

  scenario "provides API endpoints to manage resolutions" do
    get "/resolutions", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []

    post "/resolutions", auth.merge(
      issue_id: issue1_id,
      user_id: user_id,
      description: "Description",
    )
    expect(response.status).to eq(201)

    post "/resolutions", auth.merge(issue_id: issue1_id, user_id: user_id)
    expect(response.status).to eq(422)
    expect(error_messages).to include("Description can't be blank")

    post "/resolutions", auth.merge(
      issue_id: issue2_id,
      user_id: user_id,
      description: "Description",
    )
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    get "/resolutions", auth
    expect(parsed_json.size).to eq(2)

    get "/resolutions", auth.merge(issue_id: issue2_id)
    expect(parsed_json.size).to eq(1)

    get "/resolutions/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(issue_id: issue2_id)

    delete "/resolutions/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(issue_id: issue2_id)

    get "/resolutions/#{id}", auth
    expect(response.status).to eq(404)

    delete "/resolutions/#{id}", auth
    expect(response.status).to eq(404)

    get "/resolutions", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(issue_id: issue1_id),
    ]

    id = parsed_json.first.fetch(:id)

    put "/resolutions/#{id}", auth.merge(description: "New description")
    expect(response.status).to eq(200)
    expect(parsed_json).to include(description: "New description")

    put "/resolutions/#{id}", auth.merge(description: " ")
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Description can't be blank"]
  end
end
