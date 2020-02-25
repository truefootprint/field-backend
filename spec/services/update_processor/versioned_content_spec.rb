RSpec.describe UpdateProcessor::VersionedContent do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project) }
  let(:versioned_content) { FactoryBot.create(:versioned_content) }
  let(:issue) { versioned_content.subject }

  let(:period_start) { "doesn't matter" }
  let(:period_end) { "doesn't matter" }

  it "can create an issue and versioned content at the same time" do
    params = ActionController::Parameters.new(
      subject_type: ["Project", "Issue"],
      subject_id: project.id,
      text: "There's an issue",
      photos_json: "[]",
      created_at: "2020-01-01T12:00:00.000Z",
      updated_at: "2020-01-01T13:00:00.000Z",
    )

    expect { described_class.process(params, period_start, period_end, user) }
      .to change(Issue, :count).by(1)
      .and change(VersionedContent, :count).by(1)

    expect(VersionedContent.last.subject).to eq(Issue.last)
  end

  it "can create versioned content for an existing issue" do
    params = ActionController::Parameters.new(
      subject_type: "Issue",
      subject_id: issue.id,
      text: "There's an issue",
      photos_json: "[]",
      created_at: "2020-01-01T12:00:00.000Z",
      updated_at: "2020-01-01T13:00:00.000Z",
      parent_id: versioned_content.id,
    )

    expect { described_class.process(params, period_start, period_end, user) }
      .to change(Issue, :count).by(0)
      .and change(VersionedContent, :count).by(1)

    content = VersionedContent.last

    expect(content.subject).to eq(issue)
    expect(content.parent).to eq(versioned_content)
  end

  it "can create a resolution and versioned content at the same time" do
    params = ActionController::Parameters.new(
      subject_type: ["Issue", "Resolution"],
      subject_id: issue.id,
      text: "The issue is resolved",
      photos_json: "[]",
      created_at: "2020-01-01T12:00:00.000Z",
      updated_at: "2020-01-01T13:00:00.000Z",
      parent_id: versioned_content.id,
    )

    expect { described_class.process(params, period_start, period_end, user) }
      .to change(Issue, :count).by(0)
      .and change(Resolution, :count).by(1)
      .and change(VersionedContent, :count).by(1)

    resolution = Resolution.last
    resolution_content = VersionedContent.last

    expect(resolution_content.subject).to eq(resolution)

    # The resolution's content is brand new - it doesn't have a parent...
    expect(resolution_content.parent).to be_nil

    # ...but we keep track of the issue's content verion in another column
    expect(resolution.created_at_issue_content_version).to eq(versioned_content)
  end

  it "does not allow raising issues against arbitrary things" do
    params = ActionController::Parameters.new(
      subject_type: ["User", "Issue"],
      subject_id: FactoryBot.create(:user).id,
      text: "I fell out with this user",
      photos_json: "[]",
      created_at: "2020-01-01T12:00:00.000Z",
      updated_at: "2020-01-01T13:00:00.000Z",
    )

    expect { described_class.process(params, period_start, period_end, user) }
      .to raise_error(described_class::InvalidSubjectError)
  end

  it "errors if parent_id is not provided when creating a new version of existing content" do
    params = ActionController::Parameters.new(
      subject_type: "Issue",
      subject_id: issue.id,
      text: "There's an issue",
      photos_json: "[]",
      created_at: "2020-01-01T12:00:00.000Z",
      updated_at: "2020-01-01T13:00:00.000Z",
    )

    expect { described_class.process(params, period_start, period_end, user) }
      .to raise_error("key not found: :parent_id")
  end
end
