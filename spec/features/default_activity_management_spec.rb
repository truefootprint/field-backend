RSpec.describe "Default activity management" do
  let!(:user) { FactoryBot.create(:user, name: "Test") }
  let!(:role) { FactoryBot.create(:role, name: "Admin") }

  let(:auth) { { user_name: "Test", role_name: "Admin" } }

  let(:pt1_id) { post "/project_types", auth.merge(name: "pt1"); parsed_json.fetch(:id) }
  let(:pt2_id) { post "/project_types", auth.merge(name: "pt2"); parsed_json.fetch(:id) }

  let(:a1_id) { post "/activities", auth.merge(name: "a1"); parsed_json.fetch(:id) }
  let(:a2_id) { post "/activities", auth.merge(name: "a2"); parsed_json.fetch(:id) }

  scenario "provides API endpoints to manage default activities" do
    get "/default_activities", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []

    post "/default_activities", auth.merge(project_type_id: pt1_id, activity_id: a1_id, order: 1)
    expect(response.status).to eq(201)

    post "/default_activities", auth.merge(project_type_id: pt1_id, activity_id: a1_id)
    expect(response.status).to eq(422)
    expect(error_messages).to include("Order can't be blank")

    post "/default_activities", auth.merge(project_type_id: pt1_id, activity_id: a2_id, order: 2)
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    get "/default_activities", auth
    expect(parsed_json.size).to eq(2)

    get "/default_activities", auth.merge(activity_id: a1_id)
    expect(parsed_json.size).to eq(1)

    get "/default_activities/#{id}?#{presentation(project_type: true)}", auth
    expect(response.status).to eq(200)
    expect(parsed_json.dig(:project_type, :id)).to eq(pt1_id)
    id = parsed_json.fetch(:id)

    delete "/default_activities/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json.fetch(:id)).to eq(id)

    get "/default_activities/#{id}", auth
    expect(response.status).to eq(404)

    delete "/default_activities/#{id}", auth
    expect(response.status).to eq(404)

    get "/default_activities", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(order: 1),
    ]

    id = parsed_json.first.fetch(:id)

    put "/default_activities/#{id}", auth.merge(order: 3)
    expect(response.status).to eq(200)
    expect(parsed_json).to include(order: 3)

    put "/default_activities/#{id}", auth.merge(order: -1)
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Order must be greater than 0"]
  end
end
