RSpec.describe ResponseTrigger do
  describe "validations" do
    subject(:response_trigger) { FactoryBot.build(:response_trigger) }

    it "has a valid default factory" do
      expect(response_trigger).to be_valid
    end

    it "requires a value" do
      response_trigger.value = " "
      expect(response_trigger).to be_invalid
    end

    it "requires an event_name" do
      response_trigger.event_name = " "
      expect(response_trigger).to be_invalid
    end
  end
end
