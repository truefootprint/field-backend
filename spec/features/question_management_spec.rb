RSpec.describe "Question management" do
  let!(:user) { FactoryBot.create(:user, name: "Test") }
  let!(:role) { FactoryBot.create(:role, name: "Admin") }

  let(:auth) { { user_name: "Test", role_name: "Admin" } }

  let(:topic_id) do
    post "/topics", name: "Topic name"; parsed_json.fetch(:id)
  end

  scenario "provides API endpoints to manage questions" do
    get "/questions", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []

    post "/questions", auth.merge(
      topic_id: topic_id,
      type: "FreeTextQuestion",
      data_type: "string",
      text: "Question text",
      expected_length: 10,
    )
    expect(response.status).to eq(201)

    post "/questions", text: " "
    expect(response.status).to eq(422)
    expect(error_messages).to include("Text can't be blank")

    post "/questions", auth.merge(
      topic_id: topic_id,
      type: "MultiChoiceQuestion",
      data_type: "boolean",
      text: "Another question text",
      multiple_answers: true,
    )
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    get "/questions", auth
    expect(parsed_json.size).to eq(2)

    get "/questions", type: "FreeTextQuestion"
    expect(parsed_json.size).to eq(1)

    get "/questions/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(text: "Another question text")

    delete "/questions/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(text: "Another question text")

    get "/questions/#{id}", auth
    expect(response.status).to eq(404)

    delete "/questions/#{id}", auth
    expect(response.status).to eq(404)

    get "/questions", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(text: "Question text"),
    ]

    id = parsed_json.first.fetch(:id)

    put "/questions/#{id}", text: "New text"
    expect(response.status).to eq(200)
    expect(parsed_json).to include(text: "New text")

    put "/questions/#{id}", text: " "
    expect(response.status).to eq(422)
    expect(error_messages).to include("Text can't be blank")
  end
end
