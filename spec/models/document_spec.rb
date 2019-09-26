RSpec.describe Document do
  describe "validations" do
    subject(:document) { FactoryBot.build(:document) }

    it "has a valid default factory" do
      expect(document).to be_valid
    end

    it "requires a file" do
      document.file = nil
      expect(document).to be_invalid
    end
  end
end
