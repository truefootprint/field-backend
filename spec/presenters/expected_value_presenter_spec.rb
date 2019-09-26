RSpec.describe ExpectedValuePresenter do
  it "presents an expected value" do
    expected_value = FactoryBot.create(:expected_value, value: "yes")
    expect(described_class.present(expected_value)).to eq(value: "yes")
  end

  it "can present with source materials" do
    expected_value = FactoryBot.create(:expected_value)
    document = FactoryBot.create(:document, filename: "contract.pdf")

    FactoryBot.create(:source_material, subject: expected_value, document: document, page: 50)

    presented = described_class.present(expected_value, source_materials: true)
    expect(presented).to include(source_materials: [{
      page: 50,
      document: {
        file: {
          url: a_string_matching("/contract.pdf"),
        },
      },
    }])
  end
end
