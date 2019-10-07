RSpec.describe "Programme management" do
  scenario "provides API endpoints to manage programmes" do
    get "/programmes"
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []
    expect(response.headers.fetch("X-Total-Count")).to eq(0)

    post "/programmes", name: "My programme", description: "Description"
    expect(response.status).to eq(201)

    post "/programmes", name: "Another programme", description: " "
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Description can't be blank"]

    post "/programmes", name: "Another programme", description: "Description"
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    get "/programmes"
    expect(parsed_json.size).to eq(2)

    get "/programmes", name: "My programme"
    expect(parsed_json.size).to eq(1)

    get "/programmes/#{id}"
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "Another programme")

    delete "/programmes/#{id}"
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "Another programme")

    get "/programmes/#{id}"
    expect(response.status).to eq(404)

    delete "/programmes/#{id}"
    expect(response.status).to eq(404)

    get "/programmes"
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(name: "My programme"),
    ]

    id = parsed_json.first.fetch(:id)

    put "/programmes/#{id}", name: "New name"
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "New name")

    put "/programmes/#{id}", name: " "
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Name can't be blank"]
  end
end
