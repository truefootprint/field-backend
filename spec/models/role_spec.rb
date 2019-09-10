RSpec.describe Role do
  describe "validations" do
    subject(:role) { FactoryBot.build(:role) }

    it "has a valid default factory" do
      expect(role).to be_valid
    end

    it "requires a name" do
      role.name = " "
      expect(role).to be_invalid
    end
  end
end
