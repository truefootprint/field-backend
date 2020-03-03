RSpec.describe UserPresenter do
  it "presents the user's name and nothing else (no encrypted fields)" do
    user = FactoryBot.create(:user, name: "User name")

    presented = described_class.present(user)
    expect(presented).to eq(name: "User name")
  end
end
