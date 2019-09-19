RSpec.describe ProjectCompletionQuestionPresenter do
  it "presents completion question data for each project question" do
    project_question = FactoryBot.create(:project_question, id: 111)

    FactoryBot.create(
      :completion_question,
      question: project_question.question,
      completion_value: "yes",
    )

    presented = described_class.present(project_question)
    expect(presented).to eq(id: 111, completion_value: "yes")
  end
end
