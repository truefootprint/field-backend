RSpec.describe Document do
  describe "validations" do
    subject(:document) { FactoryBot.build(:document) }

    it "has a valid default factory" do
      expect(document).to be_valid
    end

    it "requires a filename" do
      document.filename = " "
      expect(document).to be_invalid
    end
  end

  describe "path" do
    it "returns the path to the document" do
      stub_const("DOCUMENTS_PATH", "/some/path")

      document = FactoryBot.build(:document, filename: "contract.pdf")

      expect(document.path).to eq("/some/path/contract.pdf")
    end
  end
end
