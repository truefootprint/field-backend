RSpec.describe Programme do
  describe "validations" do
    subject(:programme) { FactoryBot.build(:programme) }

    it "has a valid default factory" do
      expect(programme).to be_valid
    end

    it "requires a name" do
      programme.name = " "
      expect(programme).to be_invalid
    end

    it "requires a description" do
      programme.description = " "
      expect(programme).to be_invalid
    end
  end
end
