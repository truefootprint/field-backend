RSpec.describe "Expected value management" do
  let(:programme_id) do
    post "/programmes", name: "Programme name", description: "Description"
    parsed_json.fetch(:id)
  end

  let(:project_type_id) do
    post "/project_types", name: "Project Type"
    parsed_json.fetch(:id)
  end

  let(:project_id) do
    post "/projects", programme_id: programme_id, project_type_id: project_type_id, name: "Project"
    parsed_json.fetch(:id)
  end

  let(:activity_id) do
    post "/activities", name: "Activity name"; parsed_json.fetch(:id)
  end

  let(:project_activity_id) do
    post "/project_activities", project_id: project_id, activity_id: activity_id, order: 1
    parsed_json.fetch(:id)
  end

  let(:topic_id) do
    post "/topics", name: "Topic name"; parsed_json.fetch(:id)
  end

  let(:question_id) do
    post "/questions",
      topic_id: topic_id,
      type: "FreeTextQuestion",
      data_type: "string",
      text: "Question text",
      expected_length: 10
    parsed_json.fetch(:id)
  end

  let(:project_question_params) do
    { project_activity_id: project_activity_id, question_id: question_id, order: 1 }
  end

  let(:pq1_id) do
    post "/project_questions", project_question_params; parsed_json.fetch(:id)
  end

  let(:pq2_id) do
    post "/project_questions", project_question_params.merge(order: 2)
    parsed_json.fetch(:id)
  end

  scenario "provides API endpoints to manage project questions" do
    get "/expected_values"
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []
    expect(response.headers.fetch("X-Total-Count")).to eq(0)

    post "/expected_values", project_question_id: pq1_id, value: "yes"
    expect(response.status).to eq(201)

    post "/expected_values", project_question_id: pq2_id
    expect(response.status).to eq(422)
    expect(error_messages).to include("Value can't be blank")

    post "/expected_values", project_question_id: pq2_id, value: "no"
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    get "/expected_values"
    expect(parsed_json.size).to eq(2)

    get "/expected_values", value: "no"
    expect(parsed_json.size).to eq(1)

    get "/expected_values/#{id}"
    expect(response.status).to eq(200)
    expect(parsed_json).to include(value: "no")

    delete "/expected_values/#{id}"
    expect(response.status).to eq(200)
    expect(parsed_json).to include(value: "no")

    get "/expected_values/#{id}"
    expect(response.status).to eq(404)

    delete "/expected_values/#{id}"
    expect(response.status).to eq(404)

    get "/expected_values"
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(value: "yes"),
    ]

    id = parsed_json.first.fetch(:id)

    put "/expected_values/#{id}", value: "pass"
    expect(response.status).to eq(200)
    expect(parsed_json).to include(value: "pass")

    put "/expected_values/#{id}", value: " "
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Value can't be blank"]
  end
end
