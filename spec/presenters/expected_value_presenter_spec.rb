RSpec.describe ExpectedValuePresenter do
  it "presents an expected value" do
    expected_value = FactoryBot.create(:expected_value, value: "yes")
    expect(described_class.present(expected_value)).to eq(value: "yes")
  end

  it "can present with source materials" do
    stub_const("DOCUMENTS_PATH", "/some/path")

    expected_value = FactoryBot.create(:expected_value)
    document = FactoryBot.create(:document, filename: "contract.pdf")

    FactoryBot.create(:source_material, subject: expected_value, document: document, page: 50)

    presented = described_class.present(expected_value, source_materials: true)
    expect(presented).to include(source_materials: [{
      page: 50,
      document: {
        path: "/some/path/contract.pdf",
      }
    }])
  end
end
