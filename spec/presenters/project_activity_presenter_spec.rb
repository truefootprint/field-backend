RSpec.describe ProjectActivityPresenter do
  let(:activity) { FactoryBot.create(:activity, name: "Activity name") }

  let!(:project_activity) do
    FactoryBot.create(:project_activity, id: 111, activity: activity, order: 5, state: "not_started")
  end

  describe ".present" do
    it "presents a scope of project activities" do
      presented = described_class.present(ProjectActivity.all)
      expect(presented).to eq [{ id: 111, name: "Activity name", state: "not_started" }]
    end

    it "orders by the order column" do
      FactoryBot.create(:project_activity, id: 222, activity: activity, order: 4)
      FactoryBot.create(:project_activity, id: 333, activity: activity, order: 6)

      presented = described_class.present(ProjectActivity.all)
      expect(presented.map { |h| h.fetch(:id) }).to eq [222, 111, 333]
    end
  end

  describe "#as_json" do
    subject(:presenter) { described_class.new(project_activity) }

    it "presents the project activity" do
      expect(presenter.as_json).to eq(id: 111, name: "Activity name", state: "not_started")
    end
  end

  describe described_class::WithProjectQuestions::ByTopic do
    it "includes project questions chunked by topic" do
      project_question = FactoryBot.create(:project_question, id: 555, subject: project_activity)

      question = project_question.question
      question.topic.update!(name: "Topic")
      question.update!(text: "Question text")

      presented = described_class.present(ProjectActivity.all)

      expect(presented).to eq [
        {
          id: 111,
          name: "Activity name",
          state: "not_started",
          project_questions: [
            name: "Topic",
            project_questions: [
              id: 555,
              text: "Question text",
            ]
          ]
        }
      ]
    end
  end
end
