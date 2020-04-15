RSpec.describe Registration do
  describe "validations" do
    subject(:registration) { FactoryBot.build(:registration) }

    it "has a valid default factory" do
      expect(registration).to be_valid
    end

    it "requires a unique user per project/project activity" do
      existing = FactoryBot.create(:registration)
      project = existing.project_role.project

      registration.project_role = existing.project_role
      registration.user = existing.user

      expect(registration).to be_invalid

      project_activity = FactoryBot.create(:project_activity, project: project)
      registration.project_activity = project_activity

      expect(registration).to be_valid
    end

    it "requires the project_role/project_activity to have the same project" do
      registration.project_activity = FactoryBot.create(:project_activity)
      expect(registration).to be_invalid
    end
  end
end
