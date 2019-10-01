RSpec.describe "Completion question management" do
  let!(:user) { FactoryBot.create(:user, name: "Test") }
  let!(:role) { FactoryBot.create(:role, name: "Admin") }

  let(:auth) { { user_name: "Test", role_name: "Admin" } }

  let(:question_params) do
    auth.merge(topic_id: topic_id, type: "FreeTextQuestion", data_type: "string")
  end

  let(:topic_id) { post "/topics", auth.merge(name: "t1"); parsed_json.fetch(:id) }

  let(:q1_id) { post "/questions", question_params.merge(text: "q1"); parsed_json.fetch(:id) }
  let(:q2_id) { post "/questions", question_params.merge(text: "q2"); parsed_json.fetch(:id) }

  scenario "provides API endpoints to manage completion questions" do
    get "/completion_questions", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []

    post "/completion_questions", auth.merge(question_id: q1_id, completion_value: "yes")
    expect(response.status).to eq(201)

    post "/completion_questions", auth.merge(question_id: q1_id)
    expect(response.status).to eq(422)
    expect(error_messages).to include("Completion value can't be blank")

    post "/completion_questions", auth.merge(question_id: q2_id, completion_value: "no")
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    get "/completion_questions", auth
    expect(parsed_json.size).to eq(2)

    get "/completion_questions", auth.merge(question_id: q1_id)
    expect(parsed_json.size).to eq(1)

    get "/completion_questions/#{id}?#{presentation(question: true)}", auth
    expect(response.status).to eq(200)
    expect(parsed_json.dig(:question, :id)).to eq(q2_id)
    id = parsed_json.fetch(:id)

    delete "/completion_questions/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json.fetch(:id)).to eq(id)

    get "/completion_questions/#{id}", auth
    expect(response.status).to eq(404)

    delete "/completion_questions/#{id}", auth
    expect(response.status).to eq(404)

    get "/completion_questions", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(completion_value: "yes"),
    ]

    id = parsed_json.first.fetch(:id)

    put "/completion_questions/#{id}", auth.merge(completion_value: "completed")
    expect(response.status).to eq(200)
    expect(parsed_json).to include(completion_value: "completed")

    put "/completion_questions/#{id}", auth.merge(completion_value: " ")
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Completion value can't be blank"]
  end
end
