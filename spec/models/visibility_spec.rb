RSpec.describe Visibility do
  describe "validations" do
    subject(:visibility) { FactoryBot.build(:visibility) }

    it "has a valid default factory" do
      expect(visibility).to be_valid
    end
  end
end
