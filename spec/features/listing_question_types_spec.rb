RSpec.describe "Listing question types" do
  scenario "provides an endpoint to list all question types" do
    get "/question_types"
    expect(response.status).to eq(200)

    expect(parsed_json).to eq [
      { id: "FreeTextQuestion", name: "FreeTextQuestion" },
      { id: "MultiChoiceQuestion", name: "MultiChoiceQuestion" },
      { id: "PhotoUploadQuestion", name: "PhotoUploadQuestion" },
    ]
  end

  scenario "provides an endpoint to list all question data types" do
    get "/question_data_types"
    expect(response.status).to eq(200)

    expect(parsed_json).to eq [
      { id: "boolean", name: "boolean" },
      { id: "number", name: "number" },
      { id: "photo", name: "photo" },
      { id: "string", name: "string" },
    ]
  end
end
