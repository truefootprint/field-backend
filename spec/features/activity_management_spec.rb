RSpec.describe "Activity management" do
  scenario "provides API endpoints to manage activities" do
    get "/activities"
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []
    expect(response.headers.fetch("X-Total-Count")).to eq(0)

    post "/activities", name: "My activity"
    expect(response.status).to eq(201)

    post "/activities", name: " "
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Name can't be blank"]

    post "/activities", name: "Another activity"
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    get "/activities"
    expect(parsed_json.size).to eq(2)

    get "/activities", name: "My activity"
    expect(parsed_json.size).to eq(1)

    get "/activities/#{id}"
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "Another activity")

    delete "/activities/#{id}"
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "Another activity")

    get "/activities/#{id}"
    expect(response.status).to eq(404)

    delete "/activities/#{id}"
    expect(response.status).to eq(404)

    get "/activities"
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(name: "My activity"),
    ]

    id = parsed_json.first.fetch(:id)

    put "/activities/#{id}", name: "New name"
    expect(response.status).to eq(200)
    expect(parsed_json).to include(name: "New name")

    put "/activities/#{id}", name: " "
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Name can't be blank"]
  end
end
