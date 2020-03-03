RSpec.describe Issue do
  describe "validations" do
    subject(:issue) { FactoryBot.build(:issue) }

    it "has a valid default factory" do
      expect(issue).to be_valid
    end

    it "requires a uuid" do
      issue.uuid = " "
      expect(issue).to be_invalid
    end

    it "requires a valid uuid" do
      issue.uuid = "invalid"
      expect(issue).to be_invalid
    end

    it "requires an issue note" do
      issue.notes = []
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

  describe "scopes" do
    it "has a scope for resolved issues" do
      issue1 = FactoryBot.create(:issue)
      issue2 = FactoryBot.create(:issue)

      issue1.notes.first.update!(resolved: true)

      expect(Issue.resolved).to eq [issue1]
    end
  end
end
