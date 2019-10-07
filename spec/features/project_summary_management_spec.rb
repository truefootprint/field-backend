RSpec.describe "Project summary management" do
  let(:programme_id) do
    post "/programmes", name: "Programme", description: "Description"
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

  let(:another_project_id) do
    post "/projects", programme_id: programme_id, project_type_id: project_type_id, name: "Project"
    parsed_json.fetch(:id)
  end

  scenario "provides API endpoints to manage project activities" do
    get "/project_summaries"
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []
    expect(response.headers.fetch("X-Total-Count")).to eq(0)

    post "/project_summaries", project_id: project_id, text: "Summary text"
    expect(response.status).to eq(201)

    post "/project_summaries", project_id: project_id
    expect(response.status).to eq(422)
    expect(error_messages).to include("Text can't be blank")

    post "/project_summaries", project_id: another_project_id, text: "Another text"
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    get "/project_summaries"
    expect(parsed_json.size).to eq(2)

    get "/project_summaries", text: "Another text"
    expect(parsed_json.size).to eq(1)

    get "/project_summaries/#{id}"
    expect(response.status).to eq(200)
    expect(parsed_json).to include(text: "Another text")

    delete "/project_summaries/#{id}"
    expect(response.status).to eq(200)
    expect(parsed_json).to include(text: "Another text")

    get "/project_summaries/#{id}"
    expect(response.status).to eq(404)

    delete "/project_summaries/#{id}"
    expect(response.status).to eq(404)

    get "/project_summaries"
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(text: "Summary text"),
    ]

    id = parsed_json.first.fetch(:id)

    put "/project_summaries/#{id}", text: "New text"
    expect(response.status).to eq(200)
    expect(parsed_json).to include(text: "New text")

    put "/project_summaries/#{id}", text: " "
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Text can't be blank"]
  end
end
