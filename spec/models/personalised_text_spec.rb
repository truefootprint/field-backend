RSpec.describe PersonalisedText do
  describe "validations" do
    subject(:personalised_text) { FactoryBot.build(:personalised_text) }

    it "has a valid default factory" do
      expect(personalised_text).to be_valid
    end

    it "must be unique per user_interface_text/project_role" do
      existing = FactoryBot.create(:personalised_text)

      personalised_text.project_role = existing.project_role
      expect(personalised_text).to be_valid

      personalised_text.user_interface_text = existing.user_interface_text
      expect(personalised_text).to be_invalid

      personalised_text.project_role = FactoryBot.build(:project_role)
      expect(personalised_text).to be_valid
    end

    it "requires a value" do
      personalised_text.value = " "
      expect(personalised_text).to be_invalid
    end
  end
end
