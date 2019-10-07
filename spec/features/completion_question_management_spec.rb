RSpec.describe "Completion question management" do
  let(:question_params) do
    { topic_id: topic_id, type: "FreeTextQuestion", data_type: "string" }
  end

  let(:topic_id) { post "/topics", name: "t1"; parsed_json.fetch(:id) }

  let(:q1_id) { post "/questions", question_params.merge(text: "q1"); parsed_json.fetch(:id) }
  let(:q2_id) { post "/questions", question_params.merge(text: "q2"); parsed_json.fetch(:id) }

  scenario "provides API endpoints to manage completion questions" do
    get "/completion_questions"
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []
    expect(response.headers.fetch("X-Total-Count")).to eq(0)

    post "/completion_questions", question_id: q1_id, completion_value: "yes"
    expect(response.status).to eq(201)

    post "/completion_questions", question_id: q1_id
    expect(response.status).to eq(422)
    expect(error_messages).to include("Completion value can't be blank")

    post "/completion_questions", question_id: q2_id, completion_value: "no"
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    get "/completion_questions"
    expect(parsed_json.size).to eq(2)

    get "/completion_questions", question_id: q1_id
    expect(parsed_json.size).to eq(1)

    get "/completion_questions/#{id}?#{presentation(question: true)}"
    expect(response.status).to eq(200)
    expect(parsed_json.dig(:question, :id)).to eq(q2_id)
    id = parsed_json.fetch(:id)

    delete "/completion_questions/#{id}"
    expect(response.status).to eq(200)
    expect(parsed_json.fetch(:id)).to eq(id)

    get "/completion_questions/#{id}"
    expect(response.status).to eq(404)

    delete "/completion_questions/#{id}"
    expect(response.status).to eq(404)

    get "/completion_questions"
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(completion_value: "yes"),
    ]

    id = parsed_json.first.fetch(:id)

    put "/completion_questions/#{id}", completion_value: "completed"
    expect(response.status).to eq(200)
    expect(parsed_json).to include(completion_value: "completed")

    put "/completion_questions/#{id}", completion_value: " "
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Completion value can't be blank"]
  end
end
