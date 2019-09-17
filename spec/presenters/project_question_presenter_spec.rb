RSpec.describe ProjectQuestionPresenter do
  let(:question) { FactoryBot.create(:question, text: "Question text") }

  before do
    FactoryBot.create(:project_question, id: 111, question: question, order: 5)
  end

  describe ".present" do
    it "presents a scope of project questions" do
      presented = described_class.present(ProjectQuestion.all)
      expect(presented).to eq [{ id: 111, text: "Question text" }]
    end

    it "orders by the order column" do
      FactoryBot.create(:project_question, id: 222, question: question, order: 4)
      FactoryBot.create(:project_question, id: 333, question: question, order: 6)

      presented = described_class.present(ProjectQuestion.all)
      expect(presented.map { |h| h.fetch(:id) }).to eq [222, 111, 333]
    end
  end

  describe "#as_json" do
    subject(:presenter) { described_class.new(ProjectQuestion.first) }

    it "presents the project question" do
      expect(presenter.as_json).to eq(id: 111, text: "Question text")
    end
  end

  describe described_class::ByTopic do
    it "chunks project questions by topic" do
      old_topic = Topic.last.tap {|t| t.update!(name: "Old topic") }
      new_topic = FactoryBot.create(:topic, name: "New topic")

      question1 = FactoryBot.create(:question, topic: old_topic)
      question2 = FactoryBot.create(:question, topic: new_topic)
      question3 = FactoryBot.create(:question, topic: old_topic)

      FactoryBot.create(:project_question, id: 222, question: question1, order: 4)
      FactoryBot.create(:project_question, id: 333, question: question2, order: 6)
      FactoryBot.create(:project_question, id: 444, question: question3, order: 7)

      presented = described_class.present(ProjectQuestion.all)
      first, second, third = presented

      expect(first.fetch(:name)).to eq("Old topic")
      expect(second.fetch(:name)).to eq("New topic")
      expect(third.fetch(:name)).to eq("Old topic")

      expect(first.fetch(:project_questions).map { |h| h.fetch(:id) }).to eq [222, 111]
      expect(second.fetch(:project_questions).map { |h| h.fetch(:id) }).to eq [333]
      expect(third.fetch(:project_questions).map { |h| h.fetch(:id) }).to eq [444]
    end
  end
end
