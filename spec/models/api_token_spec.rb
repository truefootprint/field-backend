RSpec.describe ApiToken do
  describe "validations" do
    subject(:api_token) { FactoryBot.build(:api_token) }

    it "has a valid default factory" do
      expect(api_token).to be_valid
    end

    it "requires a token" do
      api_token.token = " " * 10
      expect(api_token).to be_invalid
    end

    it "requires a unique token" do
      FactoryBot.create(:api_token, token: "long enough token")

      api_token.token = "long enough token"
      expect(api_token).to be_invalid
    end

    it "requires a token of 10 chracters or more" do
      api_token.token = "too short"
      expect(api_token).to be_invalid

      api_token.token = "long enough token"
      expect(api_token).to be_valid
    end
  end

  describe ".generate_for" do
    it "generates an api token for a user" do
      user = FactoryBot.create(:user)
      api_token = described_class.generate_for!(user)

      expect(api_token.user).to eq(user)
      expect(api_token.token.length).to eq(24)
      expect(api_token).to be_persisted
    end
  end

  describe "#just_used!" do
    subject(:api_token) { FactoryBot.create(:api_token) }

    it "sets metadata from the field app" do
      api_token.just_used!(device_name: "Google Pixel", device_id: "abc-123")
      api_token.reload

      expect(api_token.device_name).to eq("Google Pixel")
      expect(api_token.device_id).to eq("abc-123")
      expect(api_token.device_id_bidx).to be_present
    end

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

  describe "blind index" do
    it "is populated" do
      api_token = FactoryBot.create(:api_token, device_id: "abc-123")

      expect(api_token.token_bidx).to be_present
      expect(api_token.device_id_bidx).to be_present
    end

    it "can exact match on token" do
      FactoryBot.create(:api_token, token: "long enough token")

      api_token = ApiToken.find_by(token: "long enough token")
      expect(api_token.token).to eq("long enough token")
    end

    it "can exact match on device id" do
      FactoryBot.create(:api_token, device_id: "abc-123")

      api_token = ApiToken.find_by(device_id: "abc-123")
      expect(api_token.device_id).to eq("abc-123")
    end
  end
end
