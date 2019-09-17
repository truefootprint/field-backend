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

  describe described_class::WithProjectQuestions do
    subject(:project_activity) { FactoryBot.create(:project_activity) }

    it "includes presented project questions" do
      question = FactoryBot.create(:question, text: "Question text")
      FactoryBot.create(:project_question, id: 555, subject: subject, question: question)

      expect(described_class.present(subject)).to include(
        project_questions: [{ id: 555, text: "Question text" }]
      )
    end

    describe described_class::ByTopic do
      subject(:project_activity) { FactoryBot.create(:project_activity) }

      it "includes presented project questions" do
        topic = FactoryBot.create(:topic, name: "Topic name")
        question = FactoryBot.create(:question, text: "Question text", topic: topic)

        FactoryBot.create(:project_question, id: 555, subject: subject, question: question)

        expect(described_class.present(subject)).to include(
          project_questions: {
            by_topic: [
              {
                topic: { name: "Topic name" },
                project_questions: [{ id: 555, text: "Question text" }]
              }
            ]
          }
        )
      end
    end
  end
end
