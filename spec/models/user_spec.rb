RSpec.describe User do
  describe "validations" do
    subject(:user) { FactoryBot.build(:user) }

    it "has a valid default factory" do
      expect(user).to be_valid
    end

    it "requires a name" do
      user.name = " "
      expect(user).to be_invalid
    end

    it "requires a country code" do
      user.country_code = " "
      expect(user).to be_invalid
    end

    it "requires a country code that starts with a plus (+) character" do
      user.country_code = "44"
      expect(user).to be_invalid
    end

    it "requires a phone number" do
      user.phone_number = " "
      expect(user).to be_invalid
    end

    it "requires a unique phone number" do
      FactoryBot.create(:user, phone_number: "12345")

      user.phone_number = "12345"
      expect(user).to be_invalid
    end

    it "requires a phone number that only contains digits" do
      user.phone_number = "12 3 45"
      expect(user).to be_invalid
    end
  end

  describe "blind index" do
    it "is populated" do
      user = FactoryBot.create(:user)
      expect(user.phone_number_bidx).to be_present
    end

    it "can exact match on phone number" do
      FactoryBot.create(:user, phone_number: "12345")

      user = User.find_by(phone_number: "12345")
      expect(user.phone_number).to eq("12345")
    end
  end
end
