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
  end
end
