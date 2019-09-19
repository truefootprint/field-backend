RSpec.describe CompletionQuestion do
  describe "validations" do
    subject(:completion_question) { FactoryBot.build(:completion_question) }

    it "has a valid default factory" do
      expect(completion_question).to be_valid
    end

    it "requires a completion_value" do
      completion_question.completion_value = " "
      expect(completion_question).to be_invalid
    end
  end
end
