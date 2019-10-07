RSpec.describe "User management" do
  scenario "provides API endpoints to manage users" do
    get "/users"
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []
    expect(response.headers.fetch("X-Total-Count")).to eq(0)

    post "/users", name: "User name"
    expect(response.status).to eq(201)

    post "/users", name: " "
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Name can't be blank"]

    post "/users", name: "Another user"
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    get "/users"
    expect(parsed_json.size).to eq(2)

    get "/users", name: "Another user"
    expect(parsed_json.size).to eq(1)

    get "/users/#{id}"
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "Another user")

    delete "/users/#{id}"
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "Another user")

    get "/users/#{id}"
    expect(response.status).to eq(404)

    delete "/users/#{id}"
    expect(response.status).to eq(404)

    get "/users"
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(name: "User name"),
    ]

    id = parsed_json.first.fetch(:id)

    put "/users/#{id}", name: "New name"
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "New name")

    put "/users/#{id}", name: " "
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Name can't be blank"]
  end
end
