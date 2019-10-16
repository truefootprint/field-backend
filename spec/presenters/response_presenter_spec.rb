RSpec.describe ResponsePresenter do
  it "presents a response" do
    response = FactoryBot.create(:response, value: "yes")

    presented = described_class.present(response)
    expect(presented).to include(value: "yes")
  end

  it "orders by newest first" do
    FactoryBot.create(:response, value: "111", created_at: 3.minutes.ago)
    FactoryBot.create(:response, value: "222", created_at: 2.minutes.ago)
    FactoryBot.create(:response, value: "333", created_at: 4.minutes.ago)

    presented = described_class.present(Response.all)
    expect(presented.map { |h| h.fetch(:value) }).to eq %w[222 111 333]
  end

  it "can present with the unit" do
    unit = FactoryBot.create(:unit, name: "meter", type: "length")
    response = FactoryBot.create(:response, unit: unit)

    presented = described_class.present(response, unit: true)
    expect(presented).to include(unit: hash_including(name: "meter", type: "length"))
  end

  it "can present with the photo" do
    attachment = { io: file_fixture("water-pump-working.png").open, filename: "upload.png" }
    response = FactoryBot.create(:response, photo: attachment)

    presented = described_class.present(response, photo: true)
    expect(presented).to include(photo: hash_including(url: a_string_matching("/upload.png")))
  end
end
