RSpec.describe Project do
  describe "validations" do
    subject(:project) { FactoryBot.build(:project) }

    it "has a valid default factory" do
      expect(project).to be_valid
    end

    it "requires a name" do
      project.name = " "
      expect(project).to be_invalid
    end
  end
end
