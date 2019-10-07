RSpec.describe "Follow-up activity management" do
  let!(:user) { FactoryBot.create(:user, name: "Test") }
  let!(:role) { FactoryBot.create(:role, name: "Admin") }

  let(:auth) { { user_name: "Test", role_name: "Admin" } }

  let(:a1_id) { post "/activities", name: "a1"; parsed_json.fetch(:id) }
  let(:a2_id) { post "/activities", name: "a2"; parsed_json.fetch(:id) }
  let(:a3_id) { post "/activities", name: "a3"; parsed_json.fetch(:id) }

  scenario "provides API endpoints to manage follow-up activities" do
    get "/follow_up_activities"
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []
    expect(response.headers.fetch("X-Total-Count")).to eq(0)

    post "/follow_up_activities", activity_id: a1_id, follow_up_activity_id: a2_id
    expect(response.status).to eq(201)

    post "/follow_up_activities", activity_id: a1_id, follow_up_activity: 999
    expect(response.status).to eq(422)
    expect(error_messages).to include("Follow up activity must exist")

    post "/follow_up_activities", activity_id: a2_id, follow_up_activity_id: a1_id
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    get "/follow_up_activities"
    expect(parsed_json.size).to eq(2)

    get "/follow_up_activities", activity_id: a1_id
    expect(parsed_json.size).to eq(1)

    get "/follow_up_activities/#{id}?#{presentation(activity: true)}"
    expect(response.status).to eq(200)
    expect(parsed_json.dig(:activity, :id)).to eq(a2_id)
    id = parsed_json.fetch(:id)

    delete "/follow_up_activities/#{id}"
    expect(response.status).to eq(200)
    expect(parsed_json.fetch(:id)).to eq(id)

    get "/follow_up_activities/#{id}"
    expect(response.status).to eq(404)

    delete "/follow_up_activities/#{id}"
    expect(response.status).to eq(404)

    get "/follow_up_activities?#{presentation(follow_up_activity: true)}"
    expect(response.status).to eq(200)
    expect(parsed_json.first.dig(:follow_up_activity, :id)).to eq(a2_id)
    id = parsed_json.first.fetch(:id)

    put "/follow_up_activities/#{id}", follow_up_activity_id: a3_id
    expect(response.status).to eq(200)
    expect(parsed_json).to include(follow_up_activity_id: a3_id)

    put "/follow_up_activities/#{id}", follow_up_activity_id: 999
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Follow up activity must exist"]
  end
end
