RSpec.describe User do
  describe "validations" do
    subject(:user) { FactoryBot.build(:user) }

    it "has a valid default factory" do
      expect(user).to be_valid
    end

    it "requires a name" do
      user.name = " "
      expect(user).to be_invalid
    end
  end
end
