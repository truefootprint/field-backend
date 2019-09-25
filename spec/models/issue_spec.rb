RSpec.describe Issue do
  describe "validations" do
    subject(:issue) { FactoryBot.build(:issue) }

    it "has a valid default factory" do
      expect(issue).to be_valid
    end

    it "requires a description" do
      issue.description = " "
      expect(issue).to be_invalid
    end

    it "requires whether the issue is critical" do
      issue.critical = nil
      expect(issue).to be_invalid
    end
  end
end
