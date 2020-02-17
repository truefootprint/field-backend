RSpec.describe ResolutionPresenter do
  it "presents a resolution" do
    resolution = FactoryBot.create(:resolution, content: "Resolution content")

    presented = described_class.present(resolution)
    versioned_content = presented.fetch(:versioned_content)

    expect(versioned_content).to include(content: "Resolution content")
  end

  it "can present with the user" do
    user = FactoryBot.create(:user, name: "User name")
    resolution = FactoryBot.create(:resolution, user: user)

    presented = described_class.present(resolution, user: true)
    expect(presented).to include(user: hash_including(name: "User name"))
  end
end
