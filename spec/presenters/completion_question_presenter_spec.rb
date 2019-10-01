RSpec.describe CompletionQuestionPresenter do
  it "presents a completion question" do
    completion_question = FactoryBot.create(:completion_question, id: 123, completion_value: "yes")
    expect(described_class.present(completion_question)).to include(id: 123, completion_value: "yes")
  end

  it "can present with the question" do
    question = FactoryBot.create(:question, text: "Question text")
    completion_question = FactoryBot.create(:completion_question, question: question)

    presented = described_class.present(completion_question, question: true)
    expect(presented.dig(:question, :text)).to eq("Question text")
  end
end
