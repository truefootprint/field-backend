RSpec.describe Involvement do
  describe "validations" do
    subject(:involvement) { FactoryBot.build(:involvement) }

    it "has a valid default factory" do
      expect(involvement).to be_valid
    end

    it "requires the kind of involvement" do
      involvement.kind = " "
      expect(involvement).to be_invalid
    end
  end
end
