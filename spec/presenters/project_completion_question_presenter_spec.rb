RSpec.describe ProjectCompletionQuestionPresenter do
  it "presents completion question data for each project question" do
    project_question = FactoryBot.create(:project_question, id: 111)

    FactoryBot.create(
      :completion_question,
      question: project_question.question,
      completion_value: "yes",
    )

    presented = described_class.present(project_question)
    expect(presented).to eq(project_question_id: 111, completion_value: "yes")
  end

  it "orders by project_question_id" do
    pq3 = FactoryBot.create(:project_question, id: 333)
    pq2 = FactoryBot.create(:project_question, id: 222)
    pq1 = FactoryBot.create(:project_question, id: 111)

    FactoryBot.create(:completion_question, question: pq3.question, completion_value: "yes")
    FactoryBot.create(:completion_question, question: pq2.question, completion_value: "yes")
    FactoryBot.create(:completion_question, question: pq1.question, completion_value: "yes")

    presented = described_class.present(ProjectQuestion.all)
    ids = presented.map { |h| h.fetch(:project_question_id) }

    expect(ids).to eq [111, 222, 333]
  end
end
