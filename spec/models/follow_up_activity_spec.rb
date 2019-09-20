RSpec.describe FollowUpActivity do
  describe "validations" do
    subject(:follow_up_activity) { FactoryBot.build(:follow_up_activity) }

    it "has a valid default factory" do
      expect(follow_up_activity).to be_valid
    end
  end
end
