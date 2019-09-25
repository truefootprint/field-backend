RSpec.describe ResponsePresenter do
  it "presents a response" do
    response = FactoryBot.create(:response, value: "yes")

    presented = described_class.present(response)
    expect(presented).to eq(value: "yes")
  end

  it "orders by newest first" do
    FactoryBot.create(:response, value: "111", created_at: 3.minutes.ago)
    FactoryBot.create(:response, value: "222", created_at: 2.minutes.ago)
    FactoryBot.create(:response, value: "333", created_at: 4.minutes.ago)

    presented = described_class.present(Response.all)
    expect(presented.map { |h| h.fetch(:value) }).to eq %w[222 111 333]
  end
end
