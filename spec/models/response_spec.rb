RSpec.describe Response do
  describe "validations" do
    subject(:response) { FactoryBot.build(:response) }

    it "has a valid default factory" do
      expect(response).to be_valid
    end

    it "requires a value" do
      response.value = " "
      expect(response).to be_invalid
    end
  end
end
