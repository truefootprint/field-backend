RSpec.describe ProjectQuestionPresenter do
  let(:question) { FactoryBot.create(:question, text: "Question text") }

  before do
    FactoryBot.create(:project_question, id: 123, question: question, order: 5)
  end

  describe ".present" do
    it "presents a scope of project questions" do
      presented = described_class.present(ProjectQuestion.all)
      expect(presented).to eq [{ id: 123, text: "Question text" }]
    end

    it "orders by the order column" do
      FactoryBot.create(:project_question, id: 456, question: question, order: 4)
      FactoryBot.create(:project_question, id: 789, question: question, order: 6)

      presented = described_class.present(ProjectQuestion.all)
      expect(presented.map { |h| h.fetch(:id) }).to eq [456, 123, 789]
    end
  end

  describe "#as_json" do
    subject(:presenter) { described_class.new(ProjectQuestion.first) }

    it "presents the project question" do
      expect(presenter.as_json).to eq(id: 123, text: "Question text")
    end
  end
end
