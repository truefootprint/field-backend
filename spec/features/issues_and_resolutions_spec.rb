RSpec.describe "Issues and resolutions" do
  let!(:user) { FactoryBot.create(:user, name: "Test") }
  let!(:role) { FactoryBot.create(:role, name: "Test") }

  let(:project) { FactoryBot.create(:project) }

  let(:photo) { file_fixture("water-pump-stolen.png") }
  let(:file) { Rack::Test::UploadedFile.new(photo) }

  before do
    user_role = FactoryBot.create(:user_role, user: user, role: role)
    FactoryBot.create(:visibility, subject: project, visible_to: user_role)

    allow(file).to receive(:original_filename).and_return("md5.jpg")
    authenticate_as(user)
  end

  def post_updates(updates)
    post "/my_updates", updates: updates
    expect(response.status).to eq(201)
  end

  scenario "" do
    get "/my_data"
    expect(response.status).to eq(200)

    period_start = "2020-01-01T00:00:00.000Z"
    period_end = "2020-01-01T23:59:59.000Z"

    content1 = {
      created_at: "2020-01-01T12:00:00.000Z",
      updated_at: "2020-01-01T13:00:00.000Z",
      subject_type: ["Project", "Issue"],
      subject_id: project.id,
      content: "The water pump has been stolen",
      photos_json: "[]",
      parent_id: nil,
    }

    post_updates([{ period_start: period_start, period_end: period_end, content: [content1] }])

    get "/my_data"
    expect(response.status).to eq(200)
    issue = all_projects.first.fetch(:issues).first
    content = issue.fetch(:versioned_content).fetch(:content)
    expect(issue.dig(:user, :name)).to eq("Test")
    expect(content).to eq("The water pump has been stolen")

    content2 = {
      created_at: "2020-01-01T14:00:00.000Z",
      updated_at: "2020-01-01T15:00:00.000Z",
      subject_type: "Issue",
      subject_id: issue.fetch(:id),
      content: "I contacted the contractor. Here's a photo of the pump:",
      photos_json: [{ uri: "/field-app/md5.jpg" }].to_json,
      parent_id: issue.dig(:versioned_content, :id),
    }

    post_updates([{ period_start: period_start, period_end: period_end, content: [content2] }])

    get "/my_data"
    expect(response.status).to eq(200)
    issues = all_projects.first.fetch(:issues)
    versioned_content = issues.first.fetch(:versioned_content)
    content = versioned_content.fetch(:content)
    photos = JSON.parse(versioned_content.fetch(:photos_json))

    expect(issues.size).to eq(1)
    expect(content).to eq("I contacted the contractor. Here's a photo of the pump:")
    expect(photos.size).to eq(1)

    post "/my_photos", image: file
    expect(response.status).to eq(201)

    get "/my_data"
    expect(response.status).to eq(200)
    issue = all_projects.first.fetch(:issues).first
    versioned_content = issue.fetch(:versioned_content)
    expect(versioned_content.fetch(:photos).size).to eq(1)

    content3 = {
      created_at: "2020-01-01T14:00:00.000Z",
      updated_at: "2020-01-01T15:00:00.000Z",
      subject_type: ["Issue", "Resolution"],
      subject_id: issue.fetch(:id),
      content: "The contractor has returned and fitted the water pump",
      photos_json: [{ uri: "/field-app/md5.jpg" }].to_json,
      parent_id: versioned_content.fetch(:id),
    }

    post_updates([{ period_start: period_start, period_end: period_end, content: [content3] }])

    get "/my_data"
    expect(response.status).to eq(200)
    issue = all_projects.first.fetch(:issues).first
    resolution = issue.fetch(:resolutions).first

    content1 = issue.dig(:versioned_content, :content)
    content2 = resolution.dig(:versioned_content, :content)
    photos = resolution.dig(:versioned_content, :photos)

    expect(content1).to eq("I contacted the contractor. Here's a photo of the pump:")
    expect(content2).to eq("The contractor has returned and fitted the water pump")
    expect(photos.size).to eq(1)
  end
end
