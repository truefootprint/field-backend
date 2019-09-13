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

  describe ".visible" do
    it "returns projects visible to the current viewpoint" do
      project1, _project2 = FactoryBot.create_list(:project, 2)
      visibility = FactoryBot.create(:visibility, subject: project1)

      Viewpoint.current = Viewpoint.new(user: visibility.visible_to)

      expect(Project.visible).to eq [project1]
    end
  end
end
