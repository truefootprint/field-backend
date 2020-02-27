RSpec.describe IssuePresenter do
  it "presents an issue" do
    issue = FactoryBot.create(:issue, critical: true)

    presented = described_class.present(issue)
    expect(presented).to include(critical: true)
  end

  it "can present with the user" do
    user = FactoryBot.create(:user, name: "User name")
    issue = FactoryBot.create(:issue, user: user)

    presented = described_class.present(issue, user: true)
    expect(presented.dig(:user, :name)).to eq("User name")
  end
end
