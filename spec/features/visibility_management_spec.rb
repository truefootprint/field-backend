RSpec.describe "Visibility management" do
  let!(:user) { FactoryBot.create(:user, name: "Test") }
  let!(:role) { FactoryBot.create(:role, name: "Admin") }

  let(:auth) { { user_name: "Test", role_name: "Admin" } }

  let(:programme_id) do
    post "/programmes", auth.merge(name: "Programme name", description: "Description")
    parsed_json.fetch(:id)
  end

  let(:user1_id) { post "/users", auth.merge(name: "User 1"); parsed_json.fetch(:id) }
  let(:user2_id) { post "/users", auth.merge(name: "User 2"); parsed_json.fetch(:id) }
  let(:user3_id) { post "/users", auth.merge(name: "User 3"); parsed_json.fetch(:id) }

  scenario "provides API endpoints to manage visibilities" do
    get "/visibilities", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []

    post "/visibilities", auth.merge(
      subject_type: "Programme",
      subject_id: programme_id,
      visible_to_type: "User",
      visible_to_id: user1_id,
    )
    expect(response.status).to eq(201)

    post "/visibilities", auth.merge(
      subject_type: "Programme",
      subject_id: programme_id,
      visible_to_type: "User",
    )
    expect(response.status).to eq(422)
    expect(error_messages).to include("Visible to must exist")

    post "/visibilities", auth.merge(
      subject_type: "Programme",
      subject_id: programme_id,
      visible_to_type: "User",
      visible_to_id: user2_id,
    )
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    get "/visibilities", auth
    expect(parsed_json.size).to eq(2)

    get "/visibilities", auth.merge(visible_to_id: user2_id)
    expect(parsed_json.size).to eq(1)

    get "/visibilities/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(visible_to_id: user2_id)

    delete "/visibilities/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(visible_to_id: user2_id)

    get "/visibilities/#{id}", auth
    expect(response.status).to eq(404)

    delete "/visibilities/#{id}", auth
    expect(response.status).to eq(404)

    get "/visibilities", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(visible_to_id: user1_id),
    ]

    id = parsed_json.first.fetch(:id)

    put "/visibilities/#{id}", auth.merge(visible_to_id: user3_id)
    expect(response.status).to eq(200)
    expect(parsed_json).to include(visible_to_id: user3_id)

    put "/visibilities/#{id}", auth.merge(visible_to_id: 999)
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Visible to must exist"]
  end
end
