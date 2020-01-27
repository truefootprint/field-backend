RSpec.describe ApiToken do
  describe "validations" do
    subject(:api_token) { FactoryBot.build(:api_token) }

    it "has a valid default factory" do
      expect(api_token).to be_valid
    end

    it "sets the token before validation if it is blank" do
      api_token.token = " "

      expect(api_token).to be_valid
      expect(api_token.token.length).to eq(24)
    end

    it "requires a token of 10 chracters or more" do
      api_token.token = "too short"
      expect(api_token).to be_invalid

      api_token.token = "long enough token"
      expect(api_token).to be_valid
    end
  end

  describe "#just_used!" do
    subject(:api_token) { FactoryBot.create(:api_token) }

    it "increments times_used and saves" do
      expect(api_token.times_used).to eq(0)

      api_token.just_used!
      expect(api_token.reload.times_used).to eq(1)

      api_token.just_used!
      expect(api_token.reload.times_used).to eq(2)
    end

    it "touches last_used_at and saves" do
      expect(api_token.last_used_at).to be_nil

      api_token.just_used!
      expect(api_token.reload.last_used_at).to be_present
    end
  end
end
