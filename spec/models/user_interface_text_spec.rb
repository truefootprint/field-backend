RSpec.describe UserInterfaceText do
  describe "validations" do
    subject(:user_interface_text) { FactoryBot.build(:user_interface_text) }

    it "has a default subject" do
      expect(user_interface_text).to be_valid
    end

    it "requires a key" do
      user_interface_text.key = " "
      expect(user_interface_text).to be_invalid
    end

    it "requires a unique key (case insensitive)" do
      existing = FactoryBot.create(:user_interface_text)

      user_interface_text.key = existing.key.swapcase
      expect(user_interface_text).to be_invalid
    end

    it "requires a value" do
      user_interface_text.value = " "
      expect(user_interface_text).to be_invalid
    end
  end
end
