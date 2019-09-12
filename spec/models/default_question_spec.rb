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
  end
end
