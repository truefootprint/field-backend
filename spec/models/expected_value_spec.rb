RSpec.describe ExpectedValue do
  describe "validations" do
    subject(:expected_value) { FactoryBot.build(:expected_value) }

    it "has a valid default factory" do
      expect(expected_value).to be_valid
    end

    it "requires a value" do
      expected_value.value = " "
      expect(expected_value).to be_invalid
    end

    it "requires text" do
      expected_value.text = " "
      expect(expected_value).to be_invalid
    end

    it "requires a unique project question" do
      existing = FactoryBot.create(:expected_value)

      expected_value.project_question = existing.project_question
      expect(expected_value).to be_invalid
    end
  end
end
