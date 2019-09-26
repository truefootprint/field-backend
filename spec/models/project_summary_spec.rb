RSpec.describe ProjectSummary do
  describe "validations" do
    subject(:project_summary) { FactoryBot.build(:project_summary) }

    it "has a valid default factory" do
      expect(project_summary).to be_valid
    end

    it "requires text" do
      project_summary.text = " "
      expect(project_summary).to be_invalid
    end
  end
end
