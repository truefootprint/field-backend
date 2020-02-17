RSpec.describe Issue do
  describe "validations" do
    subject(:issue) { FactoryBot.build(:issue) }

    it "has a valid default factory" do
      expect(issue).to be_valid
    end

    it "requires versioned content" do
      issue.versioned_contents = []
      expect(issue).to be_invalid
    end

    it "requires whether the issue is critical" do
      issue.critical = nil
      expect(issue).to be_invalid
    end

    it "requires a known subject type" do
      issue.subject_type = "unknown"
      expect(issue).to be_invalid
    end
  end
end
