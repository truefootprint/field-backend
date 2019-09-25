RSpec.describe IssuePresenter do
  it "presents an issue" do
    issue = FactoryBot.create(:issue, description: "Issue description", critical: true)

    presented = described_class.present(issue)
    expect(presented).to eq(description: "Issue description", critical: true)
  end

  it "can present with the user" do
    user = FactoryBot.create(:user, name: "User name")
    issue = FactoryBot.create(:issue, user: user)

    presented = described_class.present(issue, user: true)
    expect(presented).to include(user: { name: "User name" })
  end

  it "can present with photos" do
    attachment = { io: file_fixture("water-pump-stolen.png").open, filename: "stolen.png" }
    issue = FactoryBot.create(:issue, photos: [attachment])

    presented = described_class.present(issue, photos: true)
    expect(presented).to include(photos: [{ url: a_string_matching("/stolen.png") }])
  end
end
