RSpec.describe ExpectedValuePresenter do
  it "presents an expected value" do
    expected_value = FactoryBot.create(:expected_value, value: "yes")
    expect(described_class.present(expected_value)).to include(value: "yes")
  end

  it "can interpolate value and units into the text" do
    unit = FactoryBot.create(:unit, singular: "meter", plural: "meters")
    text = "It should be %{value} %{units}"

    expected_value = FactoryBot.create(:expected_value, text: text, value: "5", unit: unit)

    presented = described_class.present(expected_value, interpolate: true)
    expect(presented).to include(text: "It should be 5 meters")

    presented = described_class.present(expected_value)
    expect(presented).to include(text: "It should be %{value} %{units}")
  end
end
