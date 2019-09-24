RSpec.describe Involvement do
  describe "validations" do
    subject(:involvement) { FactoryBot.build(:involvement) }

    it "has a valid default factory" do
      expect(involvement).to be_valid
    end
  end
end
