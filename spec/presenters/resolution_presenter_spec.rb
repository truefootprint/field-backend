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

  it "can present with photos" do
    attachment = { io: file_fixture("water-pump-working.png").open, filename: "working.png" }
    resolution = FactoryBot.create(:resolution, photos: [attachment])

    presented = described_class.present(resolution, photos: true)
    expect(presented).to include(photos: [
      hash_including(url: a_string_matching("/working.png"))
    ])
  end
end
