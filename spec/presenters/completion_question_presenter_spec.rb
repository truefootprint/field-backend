RSpec.describe CompletionQuestionPresenter do
  it "presents a completion question" do
    question = FactoryBot.create(:question, id: 111)

    completion_question = FactoryBot.create(
      :completion_question,
      question: question,
      completion_value: "yes",
    )

    presented = described_class.present(completion_question)
    expect(presented).to eq(question_id: 111, completion_value: "yes")
  end
end
