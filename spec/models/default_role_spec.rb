RSpec.describe DefaultRole do
  describe "validations" do
    subject(:default_role) { FactoryBot.build(:default_role) }

    it "has a valid default factory" do
      expect(default_role).to be_valid
    end

    it "requires a unique role per project type" do
      existing = FactoryBot.create(:default_role)

      default_role.project_type = existing.project_type
      default_role.role = existing.role

      expect(default_role).to be_invalid
    end

    it "requires an order" do
      default_role.order = nil
      expect(default_role).to be_invalid
    end

    it "requires a natural number for order" do
      default_role.order = 1.5
      expect(default_role).to be_invalid

      default_role.order = 0
      expect(default_role).to be_invalid
    end
  end
end
