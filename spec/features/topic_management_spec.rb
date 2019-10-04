RSpec.describe "Topic management" do
  let!(:user) { FactoryBot.create(:user, name: "Test") }
  let!(:role) { FactoryBot.create(:role, name: "Admin") }

  let(:auth) { { user_name: "Test", role_name: "Admin" } }

  scenario "provides API endpoints to manage topics" do
    get "/topics", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []

    post "/topics", name: "My topic"
    expect(response.status).to eq(201)

    post "/topics", name: " "
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Name can't be blank"]

    post "/topics", name: "Another topic"
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    get "/topics", auth
    expect(parsed_json.size).to eq(2)

    get "/topics", name: "My topic"
    expect(parsed_json.size).to eq(1)

    get "/topics/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "Another topic")

    delete "/topics/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "Another topic")

    get "/topics/#{id}", auth
    expect(response.status).to eq(404)

    delete "/topics/#{id}", auth
    expect(response.status).to eq(404)

    get "/topics", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(name: "My topic"),
    ]

    id = parsed_json.first.fetch(:id)

    put "/topics/#{id}", name: "New name"
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "New name")

    put "/topics/#{id}", name: " "
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Name can't be blank"]
  end
end
