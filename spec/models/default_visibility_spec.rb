RSpec.describe DefaultVisibility do
  describe "validations" do
    subject(:default_visibility) { FactoryBot.build(:default_visibility) }

    it "has a valid default factory" do
      expect(default_visibility).to be_valid
    end

    it "must be unique per subject/role" do
      existing = FactoryBot.create(:default_visibility)

      default_visibility.subject = existing.subject
      expect(default_visibility).to be_valid

      default_visibility.role = existing.role
      expect(default_visibility).to be_invalid

      default_visibility.subject = FactoryBot.build(:project_type)
      expect(default_visibility).to be_valid
    end

    it "requires a known subject type" do
      default_visibility.subject_type = "unknown"
      expect(default_visibility).to be_invalid
    end
  end
end
