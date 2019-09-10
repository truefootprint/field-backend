RSpec.describe UserRole do
  describe "validations" do
    subject(:user_role) { FactoryBot.build(:user_role) }

    it "has a valid default factory" do
      expect(user_role).to be_valid
    end
  end
end
