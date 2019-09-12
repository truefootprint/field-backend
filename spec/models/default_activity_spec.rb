RSpec.describe DefaultActivity do
  describe "validations" do
    subject(:default_activity) { FactoryBot.build(:default_activity) }

    it "has a valid default factory" do
      expect(default_activity).to be_valid
    end

    it "requires an order" do
      default_activity.order = nil
      expect(default_activity).to be_invalid
    end
  end
end
