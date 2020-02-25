RSpec.describe IssuePresenter do
  it "presents an issue" do
    issue = FactoryBot.create(:issue, content: "Issue content", critical: true)

    presented = described_class.present(issue)
    expect(presented).to include(critical: true)

    versioned_content = presented.fetch(:versioned_content)
    expect(versioned_content).to include(text: "Issue content")
  end

  it "can present with the user" do
    user = FactoryBot.create(:user, name: "User name")
    issue = FactoryBot.create(:issue, user: user)

    presented = described_class.present(issue, user: true)
    expect(presented.dig(:user, :name)).to eq("User name")
  end

  it "can present with the resolution" do
    issue = FactoryBot.create(:issue)
    FactoryBot.create(:resolution, issue: issue, content: "Resolution content")

    presented = described_class.present(issue, resolutions: true)
    resolution = presented.fetch(:resolutions).first
    versioned_content = resolution.fetch(:versioned_content)

    expect(versioned_content).to include(text: "Resolution content")
  end
end
