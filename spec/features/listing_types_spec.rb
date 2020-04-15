RSpec.describe "Listing types" do
  let(:user) { FactoryBot.create(:user, name: "admin") }
  let(:role) { FactoryBot.create(:role, name: "admin") }
  let(:api_token) { FactoryBot.create(:api_token, user: user) }

  before do
    project_role = FactoryBot.create(:project_role, role: role)
    FactoryBot.create(:registration, project_role: project_role, user: user)

    basic_authorize("", api_token.token)
  end

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

  scenario "provides an endpoint to list all visibility subject types" do
    get "/visibility_subject_types"
    expect(response.status).to eq(200)

    expect(parsed_json).to include(
      { id: "Project" },
      { id: "ProjectQuestion" },
    )
  end

  scenario "provides an endpoint to list all visibility visible to types" do
    get "/visibility_visible_to_types"
    expect(response.status).to eq(200)

    expect(parsed_json).to eq [
      { id: "User" },
      { id: "ProjectRole" },
    ]
  end

  scenario "only allows admins to access these resources" do
    role.update!(name: "monitor")

    get "/question_types"
    expect(response.status).to eq(401)

    get "/question_data_types"
    expect(response.status).to eq(401)

    get "/issue_subject_types"
    expect(response.status).to eq(401)

    get "/source_material_subject_types"
    expect(response.status).to eq(401)

    get "/visibility_subject_types"
    expect(response.status).to eq(401)

    get "/visibility_visible_to_types"
    expect(response.status).to eq(401)
  end
end
