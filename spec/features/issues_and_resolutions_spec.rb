RSpec.describe "Issues and resolutions" do
  let(:user) { FactoryBot.create(:user, name: "Test") }
  let(:role) { FactoryBot.create(:role, name: "Test") }

  let(:project) { FactoryBot.create(:project) }
  let(:project_role) { FactoryBot.create(:project_role, project: project, role: role) }

  before do
    FactoryBot.create(:registration, user: user, project_role: project_role)
    FactoryBot.create(:visibility, subject: project, visible_to: project_role)

    authenticate_as(user)
  end

  def post_updates(updates)
    post "/my_updates", updates: updates
    expect(response.status).to eq(201)
  end

  scenario "receiving notes for issues and resolutions in /my_updates" do
    get "/my_data"
    expect(response.status).to eq(200)

    period_start = "2020-01-01T00:00:00.000Z"
    period_end = "2020-01-01T23:59:59.000Z"

    note1 = {
      created_at: "2020-01-01T12:00:00.000Z",
      updated_at: "2020-01-01T13:00:00.000Z",
      issue_uuid: "00000000-0000-0000-0000-000000000000",
      subject_type: "Project",
      subject_id: project.id,
      text: "The water pump has been stolen",
    }

    post_updates([{ period_start: period_start, period_end: period_end, issue_notes: [note1] }])

    get "/my_data"
    expect(response.status).to eq(200)
    issue = all_projects.first.fetch(:issues).first

    expect(issue).to include(
      created_at: note1.fetch(:created_at),
      updated_at: note1.fetch(:updated_at),
      uuid: "00000000-0000-0000-0000-000000000000",
      subject_type: "Project",
      subject_id: project.id,
      user_id: user.id,
      notes: [hash_including(
        user_id: user.id,
        text: "The water pump has been stolen",
        photos_json: "[]",
        resolved: false,
        created_at: note1.fetch(:created_at),
      )]
    )

    note2 = {
      created_at: "2020-01-01T14:00:00.000Z",
      updated_at: "2020-01-01T15:00:00.000Z",
      issue_uuid: "00000000-0000-0000-0000-000000000000",
      subject_type: "Project",
      subject_id: project.id,
      text: "The contractor has returned and fitted the pump. Here's a photo:",
      photos_json: [{ uri: "/documents/image.jpg" }].to_json,
      resolved: true,
    }

    # Post a note as another user on the same project:
    another_user = FactoryBot.create(:user, name: "Another user")
    FactoryBot.create(:registration, user: another_user, project_role: project_role)

    authenticate_as(another_user)
    post_updates([{ period_start: period_start, period_end: period_end, issue_notes: [note2] }])

    get "/my_data"
    expect(response.status).to eq(200)
    issue = all_projects.first.fetch(:issues).first

    expect(issue).to include(
      created_at: note1.fetch(:created_at),
      updated_at: note1.fetch(:updated_at), # Does not touch the issue's timestamp.
      uuid: "00000000-0000-0000-0000-000000000000",
      subject_type: "Project",
      subject_id: project.id,
      user_id: user.id,
      notes: [hash_including(
        user_id: user.id,
        text: "The water pump has been stolen",
        photos_json: "[]",
        resolved: false,
        created_at: note1.fetch(:created_at),
      ),
      hash_including(
        user_id: another_user.id,
        text: "The contractor has returned and fitted the pump. Here's a photo:",
        photos_json: [{ uri: "[[[documents]]]/image.jpg" }].to_json,
        resolved: true,
        created_at: note2.fetch(:created_at),
      )]
    )
  end
end
