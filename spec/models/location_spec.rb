RSpec.describe Location do
  describe "validations" do
    subject(:location) { FactoryBot.build(:location) }

    it "has a valid default factory" do
      expect(location).to be_valid
    end
  end
end
