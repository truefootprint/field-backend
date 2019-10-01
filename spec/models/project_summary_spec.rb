RSpec.describe ProjectSummary do
  describe "validations" do
    subject(:project_summary) { FactoryBot.build(:project_summary) }

    it "has a valid default factory" do
      expect(project_summary).to be_valid
    end

    it "requires a unique project" do
      existing = FactoryBot.create(:project_summary)

      project_summary.project = existing.project
      expect(project_summary).to be_invalid
    end

    it "requires text" do
      project_summary.text = " "
      expect(project_summary).to be_invalid
    end
  end
end
