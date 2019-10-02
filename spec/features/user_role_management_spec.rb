RSpec.describe "User role management" do
  let(:user_id) { post "/users", name: "User name"; parsed_json.fetch(:id) }

  let(:role1_id) { post "/roles", name: "Role 1"; parsed_json.fetch(:id) }
  let(:role2_id) { post "/roles", name: "Role 2"; parsed_json.fetch(:id) }
  let(:role3_id) { post "/roles", name: "Role 3"; parsed_json.fetch(:id) }

  scenario "provides API endpoints to manage user roles" do
    get "/user_roles"
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []

    post "/user_roles", user_id: user_id, role_id: role1_id
    expect(response.status).to eq(201)

    post "/user_roles", user_id: user_id
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Role must exist"]

    post "/user_roles", user_id: user_id, role_id: role2_id
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    get "/user_roles"
    expect(parsed_json.size).to eq(2)

    get "/user_roles", role_id: role2_id
    expect(parsed_json.size).to eq(1)

    get "/user_roles/#{id}"
    expect(response.status).to eq(200)
    expect(parsed_json).to include(role_id: role2_id)

    delete "/user_roles/#{id}"
    expect(response.status).to eq(200)
    expect(parsed_json).to include(role_id: role2_id)

    get "/user_roles/#{id}"
    expect(response.status).to eq(404)

    delete "/user_roles/#{id}"
    expect(response.status).to eq(404)

    get "/user_roles"
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(role_id: role1_id),
    ]

    id = parsed_json.first.fetch(:id)

    put "/user_roles/#{id}", role_id: role3_id
    expect(response.status).to eq(200)
    expect(parsed_json).to include(role_id: role3_id)

    put "/user_roles/#{id}", role_id: 999
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Role must exist"]
  end
end
