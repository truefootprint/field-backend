RSpec.describe FreeTextQuestion do
  describe "validations" do
    subject(:free_text_question) { FactoryBot.build(:free_text_question) }

    it "has a valid default factory" do
      expect(free_text_question).to be_valid
    end
  end
end
