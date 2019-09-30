RSpec.describe DefaultQuestionPresenter do
  it "presents a default question" do
    default_question = FactoryBot.create(:default_question, id: 123, order: 5)
    expect(described_class.present(default_question)).to include(id: 123, order: 5)
  end

  it "can present with the activity" do
    activity = FactoryBot.create(:activity, name: "Activity name")
    default_question = FactoryBot.create(:default_question, activity: activity)

    presented = described_class.present(default_question, activity: true)
    expect(presented.dig(:activity, :name)).to eq("Activity name")
  end

  it "can present with the question" do
    question = FactoryBot.create(:question, text: "Question text")
    default_question = FactoryBot.create(:default_question, question: question)

    presented = described_class.present(default_question, question: true)
    expect(presented.dig(:question, :text)).to eq("Question text")
  end
end
