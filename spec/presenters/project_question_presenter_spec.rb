RSpec.describe ProjectQuestionPresenter do
  it "presents the project question" do
    question = FactoryBot.create(:question, text: "Question text")
    FactoryBot.create(:project_question, id: 111, question: question, order: 5)

    presented = described_class.present(ProjectQuestion.last)
    expect(presented).to eq(id: 111, text: "Question text")
  end

  it "orders by the order column" do
    FactoryBot.create(:project_question, id: 111, order: 5)
    FactoryBot.create(:project_question, id: 222, order: 6)
    FactoryBot.create(:project_question, id: 333, order: 4)

    presented = described_class.present(ProjectQuestion.all)
    expect(presented.map { |h| h.fetch(:id) }).to eq [333, 111, 222]
  end

  describe described_class::ByTopic do
    it "chunks project questions by topic" do
      topic1 = FactoryBot.create(:topic, name: "Topic 1")
      topic2 = FactoryBot.create(:topic, name: "Topic 2")

      question1 = FactoryBot.create(:question, topic: topic1)
      question2 = FactoryBot.create(:question, topic: topic1)
      question3 = FactoryBot.create(:question, topic: topic2)
      question4 = FactoryBot.create(:question, topic: topic2)

      FactoryBot.create(:project_question, id: 111, question: question1, order: 5)
      FactoryBot.create(:project_question, id: 222, question: question2, order: 6)
      FactoryBot.create(:project_question, id: 333, question: question3, order: 7)
      FactoryBot.create(:project_question, id: 444, question: question4, order: 4)

      presented = described_class.present(ProjectQuestion.all)
      first, second, third = presented

      expect(first.dig(:topic, :name)).to eq("Topic 2")
      expect(second.dig(:topic, :name)).to eq("Topic 1")
      expect(third.dig(:topic, :name)).to eq("Topic 2")

      expect(first.fetch(:project_questions).map { |h| h.fetch(:id) }).to eq [444]
      expect(second.fetch(:project_questions).map { |h| h.fetch(:id) }).to eq [111, 222]
      expect(third.fetch(:project_questions).map { |h| h.fetch(:id) }).to eq [333]
    end
  end
end
