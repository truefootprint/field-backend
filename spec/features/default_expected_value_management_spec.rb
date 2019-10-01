RSpec.describe "Default expected value management" do
  let!(:user) { FactoryBot.create(:user, name: "Test") }
  let!(:role) { FactoryBot.create(:role, name: "Admin") }

  let(:auth) { { user_name: "Test", role_name: "Admin" } }

  let(:question_params) do
    auth.merge(topic_id: topic_id, type: "FreeTextQuestion", data_type: "string")
  end

  let(:topic_id) { post "/topics", auth.merge(name: "t1"); parsed_json.fetch(:id) }

  let(:q1_id) { post "/questions", question_params.merge(text: "q1"); parsed_json.fetch(:id) }
  let(:q2_id) { post "/questions", question_params.merge(text: "q2"); parsed_json.fetch(:id) }

  scenario "provides API endpoints to manage default expected values" do
    get "/default_expected_values", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []

    post "/default_expected_values", auth.merge(question_id: q1_id, value: "123")
    expect(response.status).to eq(201)

    post "/default_expected_values", auth.merge(question_id: q1_id)
    expect(response.status).to eq(422)
    expect(error_messages).to include("Value can't be blank")

    post "/default_expected_values", auth.merge(question_id: q2_id, value: "456")
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    get "/default_expected_values", auth
    expect(parsed_json.size).to eq(2)

    get "/default_expected_values", auth.merge(question_id: q1_id)
    expect(parsed_json.size).to eq(1)

    get "/default_expected_values/#{id}?#{presentation(question: true)}", auth
    expect(response.status).to eq(200)
    expect(parsed_json.dig(:question, :id)).to eq(q2_id)
    id = parsed_json.fetch(:id)

    delete "/default_expected_values/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json.fetch(:id)).to eq(id)

    get "/default_expected_values/#{id}", auth
    expect(response.status).to eq(404)

    delete "/default_expected_values/#{id}", auth
    expect(response.status).to eq(404)

    get "/default_expected_values", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(value: "123"),
    ]

    id = parsed_json.first.fetch(:id)

    put "/default_expected_values/#{id}", auth.merge(value: "789")
    expect(response.status).to eq(200)
    expect(parsed_json).to include(value: "789")

    put "/default_expected_values/#{id}", auth.merge(value: " ")
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Value can't be blank"]
  end
end
