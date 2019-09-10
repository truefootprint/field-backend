RSpec.describe Activity do
  describe "validations" do
    subject(:activity) { FactoryBot.build(:activity) }

    it "has a valid default factory" do
      expect(activity).to be_valid
    end

    it "requires a name" do
      activity.name = " "
      expect(activity).to be_invalid
    end
  end
end
