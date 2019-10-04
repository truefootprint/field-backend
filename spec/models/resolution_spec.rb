RSpec.describe Resolution do
  describe "validations" do
    subject(:resolution) { FactoryBot.build(:resolution) }

    it "has a valid default factory" do
      expect(resolution).to be_valid
    end

    it "requires a description" do
      resolution.description = " "
      expect(resolution).to be_invalid
    end

    it "requires a unique issue" do
      existing = FactoryBot.create(:resolution)

      resolution.issue = existing.issue
      expect(resolution).to be_invalid
    end
  end
end
