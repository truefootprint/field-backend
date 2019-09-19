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

  describe ".visible_to" do
    it "returns projects visible to the viewpoint" do
      project1, _project2 = FactoryBot.create_list(:project, 2)
      visibility = FactoryBot.create(:visibility, subject: project1)

      viewpoint = Viewpoint.new(user: visibility.visible_to)

      expect(Project.visible_to(viewpoint)).to eq [project1]
    end

    it "includes projects whose project_type is visible" do
      project1, _project2 = FactoryBot.create_list(:project, 2)
      visibility = FactoryBot.create(:visibility, subject: project1.project_type)

      viewpoint = Viewpoint.new(user: visibility.visible_to)

      expect(Project.visible_to(viewpoint)).to eq [project1]
    end
  end
end
