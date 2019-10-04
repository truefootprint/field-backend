RSpec.describe "Issue management" do
  let!(:user) { FactoryBot.create(:user, name: "Test") }
  let!(:role) { FactoryBot.create(:role, name: "Admin") }

  let(:auth) { { user_name: "Test", role_name: "Admin" } }

  let(:programme_id) do
    post "/programmes", name: "Programme name", description: "Description"
    parsed_json.fetch(:id)
  end

  let(:user_id) do
    post "/users", name: "User 1"
    parsed_json.fetch(:id)
  end

  scenario "provides API endpoints to manage issues" do
    get "/issues", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []

    post "/issues", auth.merge(
      subject_type: "Programme",
      subject_id: programme_id,
      user_id: user_id,
      description: "Description",
    )
    expect(response.status).to eq(201)

    post "/issues", auth.merge(
      subject_type: "Programme",
      subject_id: programme_id,
      user_id: user_id,
    )
    expect(response.status).to eq(422)
    expect(error_messages).to include("Description can't be blank")

    post "/issues", auth.merge(
      subject_type: "Programme",
      subject_id: programme_id,
      user_id: user_id,
      description: "Another description",
    )
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    get "/issues", auth
    expect(parsed_json.size).to eq(2)

    get "/issues", description: "Another description"
    expect(parsed_json.size).to eq(1)

    get "/issues/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(description: "Another description")

    delete "/issues/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(description: "Another description")

    get "/issues/#{id}", auth
    expect(response.status).to eq(404)

    delete "/issues/#{id}", auth
    expect(response.status).to eq(404)

    get "/issues", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(description: "Description"),
    ]

    id = parsed_json.first.fetch(:id)

    put "/issues/#{id}", description: "New description"
    expect(response.status).to eq(200)
    expect(parsed_json).to include(description: "New description")

    put "/issues/#{id}", description: " "
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Description can't be blank"]
  end
end
