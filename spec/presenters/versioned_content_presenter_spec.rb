RSpec.describe VersionedContentPresenter do
  it "can present with photos" do
    attachment = { io: file_fixture("water-pump-stolen.png").open, filename: "stolen.png" }
    record = FactoryBot.create(:versioned_content, photos: [attachment])

    presented = described_class.present(record, photos: true)
    expect(presented).to include(photos: [
      hash_including(url: a_string_matching("/stolen.png"))
    ])
  end
end
