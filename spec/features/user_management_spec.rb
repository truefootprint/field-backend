RSpec.describe "User management" do
  let!(:user) { FactoryBot.create(:user, name: "Test") }
  let!(:role) { FactoryBot.create(:role, name: "Admin") }

  let(:auth) { { user_name: "Test", role_name: "Admin" } }

  scenario "provides API endpoints to manage users" do
    get "/users"
    expect(response.status).to eq(200)
    #expect(parsed_json).to eq [] # TODO

    post "/users", name: "User name"
    expect(response.status).to eq(201)

    post "/users", auth.merge(name: " ")
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Name can't be blank"]

    post "/users", auth.merge(name: "Another user")
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    get "/users", auth
    expect(parsed_json.size).to eq(3) # TODO

    get "/users", auth.merge(name: "Another user")
    expect(parsed_json.size).to eq(1)

    get "/users/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "Another user")

    delete "/users/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "Another user")

    get "/users/#{id}", auth
    expect(response.status).to eq(404)

    delete "/users/#{id}", auth
    expect(response.status).to eq(404)

    get "/users", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(name: "Test"), # TODO
      hash_including(name: "User name"),
    ]

    id = parsed_json.first.fetch(:id)

    put "/users/#{id}", auth.merge(name: "New name")
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "New name")

    put "/users/#{id}", auth.merge(name: " ")
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Name can't be blank"]
  end
end
