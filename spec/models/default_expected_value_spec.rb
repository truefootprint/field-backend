RSpec.describe DefaultExpectedValue do
  describe "validations" do
    subject(:default_expected_value) { FactoryBot.build(:default_expected_value) }

    it "has a valid default factory" do
      expect(default_expected_value).to be_valid
    end

    it "requires a value" do
      default_expected_value.value = " "
      expect(default_expected_value).to be_invalid
    end
  end
end
