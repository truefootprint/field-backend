RSpec.describe MultiChoiceQuestion do
  describe "validations" do
    subject(:multi_choice_question) { FactoryBot.build(:multi_choice_question) }

    it "has a valid default factory" do
      expect(multi_choice_question).to be_valid
    end

    it "requires whether or not it allows multiple answers" do
      multi_choice_question.multiple_answers = nil
      expect(multi_choice_question).to be_invalid
    end
  end
end
