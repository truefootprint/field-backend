RSpec.describe ProjectQuestion do
  describe "validations" do
    subject(:project_question) { FactoryBot.build(:project_question) }

    it "has a valid default factory" do
      expect(project_question).to be_valid
    end

    it "requires an order" do
      project_question.order = nil
      expect(project_question).to be_invalid
    end
  end

  describe "#project" do
    it "returns the subject when the question is about a project" do
      project = FactoryBot.create(:project)
      project_question = FactoryBot.create(:project_question, subject: project)

      expect(project_question.project).to eq(project)
    end

    it "returns the activity's project when the question is about an activity" do
      project_activity = FactoryBot.create(:project_activity)
      project_question = FactoryBot.create(:project_question, subject: project_activity)

      expect(project_question.project).to eq(project_activity.project)
    end
  end
end
