RSpec.describe "Listing types" do
  scenario "provides an endpoint to list all question types" do
    get "/question_types"
    expect(response.status).to eq(200)

    expect(parsed_json).to eq [
      { id: "FreeTextQuestion" },
      { id: "MultiChoiceQuestion" },
      { id: "PhotoUploadQuestion" },
    ]
  end

  scenario "provides an endpoint to list all question data types" do
    get "/question_data_types"
    expect(response.status).to eq(200)

    expect(parsed_json).to eq [
      { id: "boolean" },
      { id: "number" },
      { id: "photo" },
      { id: "string" },
    ]
  end

  scenario "provides an endpoint to list all issue subject types" do
    get "/issue_subject_types"
    expect(response.status).to eq(200)

    expect(parsed_json).to eq [
      { id: "Project" },
      { id: "ProjectActivity" },
      { id: "ProjectQuestion" },
    ]
  end

  scenario "provides an endpoint to list all source material subject types" do
    get "/source_material_subject_types"
    expect(response.status).to eq(200)

    expect(parsed_json).to eq [
      { id: "Project" },
      { id: "ProjectActivity" },
    ]
  end
end
