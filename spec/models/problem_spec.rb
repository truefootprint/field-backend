RSpec.describe Problem do
  describe "validations" do
    subject(:problem) { FactoryBot.build(:problem) }

    it "has a valid default factory" do
      expect(problem).to be_valid
    end

    it "requires one of the states" do
      problem.state = "invalid"
      expect(problem).to be_invalid
    end
  end
end
