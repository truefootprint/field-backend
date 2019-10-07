RSpec.describe "Role management" do
  scenario "provides API endpoints to manage roles" do
    get "/roles"
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []
    expect(response.headers.fetch("X-Total-Count")).to eq(0)

    post "/roles", name: "Role name"
    expect(response.status).to eq(201)

    post "/roles", name: " "
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Name can't be blank"]

    post "/roles", name: "Another role"
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    get "/roles"
    expect(parsed_json.size).to eq(2)

    get "/roles", name: "Another role"
    expect(parsed_json.size).to eq(1)

    get "/roles/#{id}"
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "Another role")

    delete "/roles/#{id}"
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "Another role")

    get "/roles/#{id}"
    expect(response.status).to eq(404)

    delete "/roles/#{id}"
    expect(response.status).to eq(404)

    get "/roles"
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(name: "Role name"),
    ]

    id = parsed_json.first.fetch(:id)

    put "/roles/#{id}", name: "New name"
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "New name")

    put "/roles/#{id}", name: " "
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Name can't be blank"]
  end
end
