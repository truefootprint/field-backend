RSpec.describe IssuePresenter do
  it "presents an issue" do
    issue = FactoryBot.create(:issue, description: "Issue description", critical: true)

    presented = described_class.present(issue)
    expect(presented).to include(description: "Issue description", critical: true)
  end

  it "can present with the user" do
    user = FactoryBot.create(:user, name: "User name")
    issue = FactoryBot.create(:issue, user: user)

    presented = described_class.present(issue, user: true)
    expect(presented.dig(:user, :name)).to eq("User name")
  end

  it "can present with photos" do
    attachment = { io: file_fixture("water-pump-stolen.png").open, filename: "stolen.png" }
    issue = FactoryBot.create(:issue, photos: [attachment])

    presented = described_class.present(issue, photos: true)
    expect(presented).to include(photos: [{ url: a_string_matching("/stolen.png") }])
  end

  it "can present with the resolution" do
    issue = FactoryBot.create(:issue)
    FactoryBot.create(:resolution, issue: issue, description: "Resolution description")

    presented = described_class.present(issue, resolution: true)
    expect(presented.dig(:resolution, :description)).to eq("Resolution description")
  end
end
