RSpec.describe "Activity management" do
  let!(:user) { FactoryBot.create(:user, name: "Test") }
  let!(:role) { FactoryBot.create(:role, name: "Admin") }

  let(:auth) { { user_name: "Test", role_name: "Admin" } }

  scenario "provides API endpoints to manage activities" do
    get "/activities", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []

    post "/activities", auth.merge(name: "My activity")
    expect(response.status).to eq(201)

    post "/activities", auth.merge(name: " ")
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Name can't be blank"]

    post "/activities", auth.merge(name: "Another activity")
    expect(response.status).to eq(201)

    get "/activities", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(name: "My activity"),
      hash_including(name: "Another activity"),
    ]

    id = parsed_json.first.fetch(:id)

    get "/activities/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "My activity")

    delete "/activities/#{id}", auth
    expect(response.status).to eq(204)

    get "/activities/#{id}", auth
    expect(response.status).to eq(404)

    delete "/activities/#{id}", auth
    expect(response.status).to eq(404)

    get "/activities", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(name: "Another activity"),
    ]

    id = parsed_json.first.fetch(:id)

    put "/activities/#{id}", auth.merge(name: "New name")
    expect(response.status).to eq(204)

    get "/activities/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "New name")

    put "/activities/#{id}", auth.merge(name: " ")
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Name can't be blank"]
  end
end
