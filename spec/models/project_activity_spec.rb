RSpec.describe ProjectActivity do
  describe "validations" do
    subject(:project_activity) { FactoryBot.build(:project_activity) }

    it "has a valid default factory" do
      expect(project_activity).to be_valid
    end

    it "requires one of the states" do
      project_activity.state = "invalid"
      expect(project_activity).to be_invalid
    end
  end
end
