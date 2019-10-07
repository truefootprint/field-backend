RSpec.describe "Default activity management" do
  let(:pt1_id) { post "/project_types", name: "pt1"; parsed_json.fetch(:id) }

  let(:a1_id) { post "/activities", name: "a1"; parsed_json.fetch(:id) }
  let(:a2_id) { post "/activities", name: "a2"; parsed_json.fetch(:id) }

  scenario "provides API endpoints to manage default activities" do
    get "/default_activities"
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []
    expect(response.headers.fetch("X-Total-Count")).to eq(0)

    post "/default_activities", project_type_id: pt1_id, activity_id: a1_id, order: 1
    expect(response.status).to eq(201)

    post "/default_activities", project_type_id: pt1_id, activity_id: a1_id
    expect(response.status).to eq(422)
    expect(error_messages).to include("Order can't be blank")

    post "/default_activities", project_type_id: pt1_id, activity_id: a2_id, order: 2
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    get "/default_activities"
    expect(parsed_json.size).to eq(2)

    get "/default_activities", activity_id: a1_id
    expect(parsed_json.size).to eq(1)

    get "/default_activities/#{id}?#{presentation(project_type: true)}"
    expect(response.status).to eq(200)
    expect(parsed_json.dig(:project_type, :id)).to eq(pt1_id)
    id = parsed_json.fetch(:id)

    delete "/default_activities/#{id}"
    expect(response.status).to eq(200)
    expect(parsed_json.fetch(:id)).to eq(id)

    get "/default_activities/#{id}"
    expect(response.status).to eq(404)

    delete "/default_activities/#{id}"
    expect(response.status).to eq(404)

    get "/default_activities"
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(order: 1),
    ]

    id = parsed_json.first.fetch(:id)

    put "/default_activities/#{id}", order: 3
    expect(response.status).to eq(200)
    expect(parsed_json).to include(order: 3)

    put "/default_activities/#{id}", order: -1
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Order must be greater than 0"]
  end
end
