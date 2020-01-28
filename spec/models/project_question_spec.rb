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

    it "requires a natural number for order" do
      project_question.order = 1.5
      expect(project_question).to be_invalid

      project_question.order = 0
      expect(project_question).to be_invalid
    end
  end

  describe ".visible_to" do
    it "returns project_questions visible to the viewpoint" do
      pq1, _pq2 = FactoryBot.create_list(:project_question, 2)
      visibility = FactoryBot.create(:visibility, subject: pq1)

      viewpoint = Viewpoint.new(users: visibility.visible_to)

      expect(ProjectQuestion.visible_to(viewpoint)).to eq [pq1]
    end

    it "includes project_questions whose question is visible" do
      pq1, _pq2 = FactoryBot.create_list(:project_question, 2)
      visibility = FactoryBot.create(:visibility, subject: pq1.question)

      viewpoint = Viewpoint.new(users: visibility.visible_to)

      expect(ProjectQuestion.visible_to(viewpoint)).to eq [pq1]
    end
  end

  describe ".topics" do
    it "returns topics for the current scope of project questions" do
      topic = FactoryBot.create(:topic, name: "Topic name")
      question = FactoryBot.create(:question, topic: topic)

      FactoryBot.create(:project_question, question: question)

      expect(ProjectQuestion.all.topics).to eq [topic]
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
end
