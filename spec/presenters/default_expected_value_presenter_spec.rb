RSpec.describe DefaultExpectedValuePresenter do
  it "presents a default expected value" do
    default_expected_value = FactoryBot.create(:default_expected_value, id: 123, value: "123")
    expect(described_class.present(default_expected_value)).to include(id: 123, value: "123")
  end

  it "can present with the question" do
    question = FactoryBot.create(:question, text: "Question text")
    default_expected_value = FactoryBot.create(:default_expected_value, question: question)

    presented = described_class.present(default_expected_value, question: true)
    expect(presented.dig(:question, :text)).to eq("Question text")
  end

  it "can present with the activity" do
    activity = FactoryBot.create(:activity, name: "Activity name")
    default_expected_value = FactoryBot.create(:default_expected_value, activity: activity)

    presented = described_class.present(default_expected_value, activity: true)
    expect(presented.dig(:activity, :name)).to eq("Activity name")
  end
end
