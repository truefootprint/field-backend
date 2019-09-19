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

  describe ".visible_to" do
    it "returns project_questions visible to the viewpoint" do
      pq1, _pq2 = FactoryBot.create_list(:project_question, 2)
      visibility = FactoryBot.create(:visibility, subject: pq1)

      viewpoint = Viewpoint.new(user: visibility.visible_to)

      expect(ProjectQuestion.visible_to(viewpoint)).to eq [pq1]
    end

    it "includes project_questions whose question is visible" do
      pq1, _pq2 = FactoryBot.create_list(:project_question, 2)
      visibility = FactoryBot.create(:visibility, subject: pq1.question)

      viewpoint = Viewpoint.new(user: visibility.visible_to)

      expect(ProjectQuestion.visible_to(viewpoint)).to eq [pq1]
    end
  end

  describe ".completion_questions" do
    it "returns completion questions for the current scope of project questions" do
      project_question = FactoryBot.create(:project_question)
      completion_question = FactoryBot.create(:completion_question, question: project_question.question)

      expect(ProjectQuestion.all.completion_questions).to eq [completion_question]
      expect(ProjectQuestion.visible.completion_questions).to eq []
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
