RSpec.describe ProjectActivityPresenter do
  it "presents the project activity" do
    activity = FactoryBot.create(:activity, name: "Activity name")
    FactoryBot.create(:project_activity, id: 111, activity: activity, order: 5, state: "not_started")

    presented = described_class.present(ProjectActivity.last)
    expect(presented).to eq(id: 111, name: "Activity name", state: "not_started")
  end

  it "orders by the order column" do
    FactoryBot.create(:project_activity, id: 111, order: 5)
    FactoryBot.create(:project_activity, id: 222, order: 6)
    FactoryBot.create(:project_activity, id: 333, order: 4)

    presented = described_class.present(ProjectActivity.all)
    expect(presented.map { |h| h.fetch(:id) }).to eq [333, 111, 222]
  end

  describe "variants" do
    subject(:project_activity) { FactoryBot.create(:project_activity) }
    let(:question) { FactoryBot.create(:question, text: "Question text") }

    before do
      FactoryBot.create(
        :project_question,
        id: 555,
        subject: project_activity,
        question: question,
      )
    end

    it "can present project activities with project questions" do
      presenter = described_class::WithProjectQuestions

      expect(presenter.present(project_activity)).to include(
        project_questions: [{ id: 555, text: "Question text" }]
      )
    end

    it "can present project activities with project questions by topic" do
      presenter = described_class::WithProjectQuestions::ByTopic
      presented = presenter.present(project_activity)

      expect(presented.dig(:project_questions, :by_topic)).not_to be_nil
    end
  end
end
