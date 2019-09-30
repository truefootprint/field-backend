RSpec.describe "Default question management" do
  let!(:user) { FactoryBot.create(:user, name: "Test") }
  let!(:role) { FactoryBot.create(:role, name: "Admin") }

  let(:auth) { { user_name: "Test", role_name: "Admin" } }

  let(:question_params) do
    auth.merge(topic_id: topic_id, type: "FreeTextQuestion", data_type: "string")
  end

  let(:topic_id) { post "/topics", auth.merge(name: "t1"); parsed_json.fetch(:id) }

  let(:a1_id) { post "/activities", auth.merge(name: "a1"); parsed_json.fetch(:id) }

  let(:q1_id) { post "/questions", question_params.merge(text: "q1"); parsed_json.fetch(:id) }
  let(:q2_id) { post "/questions", question_params.merge(text: "q2"); parsed_json.fetch(:id) }

  scenario "provides API endpoints to manage default questions" do
    get "/default_questions", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []

    post "/default_questions", auth.merge(activity_id: a1_id, question_id: q1_id, order: 1)
    expect(response.status).to eq(201)

    post "/default_questions", auth.merge(activity_id: a1_id, question_id: q1_id)
    expect(response.status).to eq(422)
    expect(error_messages).to include("Order can't be blank")

    post "/default_questions", auth.merge(activity_id: a1_id, question_id: q2_id, order: 2)
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    get "/default_questions", auth
    expect(parsed_json.size).to eq(2)

    get "/default_questions", auth.merge(question_id: q1_id)
    expect(parsed_json.size).to eq(1)

    get "/default_questions/#{id}?#{presentation(activity: true)}", auth
    expect(response.status).to eq(200)
    expect(parsed_json.dig(:activity, :id)).to eq(a1_id)
    id = parsed_json.fetch(:id)

    delete "/default_questions/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json.fetch(:id)).to eq(id)

    get "/default_questions/#{id}", auth
    expect(response.status).to eq(404)

    delete "/default_questions/#{id}", auth
    expect(response.status).to eq(404)

    get "/default_questions", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(order: 1),
    ]

    id = parsed_json.first.fetch(:id)

    put "/default_questions/#{id}", auth.merge(order: 3)
    expect(response.status).to eq(200)
    expect(parsed_json).to include(order: 3)

    put "/default_questions/#{id}", auth.merge(order: -1)
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Order must be greater than 0"]
  end
end
