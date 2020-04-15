RSpec.describe ProjectType do
  describe "validations" do
    subject(:project_type) { FactoryBot.build(:project_type) }

    it "has a valid default factory" do
      expect(project_type).to be_valid
    end

    it "requires a name" do
      project_type.name = " "
      expect(project_type).to be_invalid
    end

    it "requires a unique name" do
      FactoryBot.create(:project_type, name: "Name")

      project_type.name = "name"
      expect(project_type).to be_invalid
    end
  end
end
