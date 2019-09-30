RSpec.describe "Programme management" do
  let!(:user) { FactoryBot.create(:user, name: "Test") }
  let!(:role) { FactoryBot.create(:role, name: "Admin") }

  let(:auth) { { user_name: "Test", role_name: "Admin" } }

  scenario "provides API endpoints to manage programmes" do
    get "/programmes", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []

    post "/programmes", auth.merge(name: "My programme", description: "Description")
    expect(response.status).to eq(201)

    post "/programmes", auth.merge(name: "Another programme", description: " ")
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Description can't be blank"]

    post "/programmes", auth.merge(name: "Another programme", description: "Description")
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    get "/programmes/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "Another programme")

    delete "/programmes/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "Another programme")

    get "/programmes/#{id}", auth
    expect(response.status).to eq(404)

    delete "/programmes/#{id}", auth
    expect(response.status).to eq(404)

    get "/programmes", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(name: "My programme"),
    ]

    id = parsed_json.first.fetch(:id)

    put "/programmes/#{id}", auth.merge(name: "New name")
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "New name")

    put "/programmes/#{id}", auth.merge(name: " ")
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Name can't be blank"]
  end
end
