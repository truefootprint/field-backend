RSpec.describe UserPresenter do
  it "presents the user's id and name (no encrypted fields)" do
    user = FactoryBot.create(:user, name: "User name")

    presented = described_class.present(user)
    expect(presented).to eq(id: user.id, name: "User name")
  end
end
