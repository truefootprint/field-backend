RSpec.describe IssueNotePresenter do
  it "presents an issue note" do
    response = FactoryBot.create(:issue_note, text: "text")

    presented = described_class.present(response)
    expect(presented).to include(text: "text")
  end

  it "orders chronologically" do
    FactoryBot.create(:issue_note, text: "111", created_at: 3.minutes.ago)
    FactoryBot.create(:issue_note, text: "222", created_at: 2.minutes.ago)
    FactoryBot.create(:issue_note, text: "333", created_at: 4.minutes.ago)

    presented = described_class.present(IssueNote.all)
    expect(presented.map { |h| h.fetch(:text) }).to eq %w[333 111 222]
  end

  it "can present with the user" do
    user = FactoryBot.create(:user, name: "User name")
    note = FactoryBot.create(:issue_note, user: user)

    presented = described_class.present(note, user: true)
    expect(presented.dig(:user, :name)).to eq("User name")
  end
end
