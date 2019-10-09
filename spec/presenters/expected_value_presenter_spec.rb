RSpec.describe ExpectedValuePresenter do
  it "presents an expected value" do
    expected_value = FactoryBot.create(:expected_value, value: "yes")
    expect(described_class.present(expected_value)).to include(value: "yes")
  end
end
