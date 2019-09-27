RSpec.describe DefaultQuestion do
  describe "validations" do
    subject(:default_question) { FactoryBot.build(:default_question) }

    it "has a valid default factory" do
      expect(default_question).to be_valid
    end

    it "requires an order" do
      default_question.order = nil
      expect(default_question).to be_invalid
    end

    it "requires a natural number for order" do
      default_question.order = 1.5
      expect(default_question).to be_invalid

      default_question.order = 0
      expect(default_question).to be_invalid
    end
  end
end
