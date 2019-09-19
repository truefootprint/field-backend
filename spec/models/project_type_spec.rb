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

  describe ".visible_to" do
    it "returns project_types visible from the current viewpoint" do
      pt1, _pt2 = FactoryBot.create_list(:project_type, 2)
      visibility = FactoryBot.create(:visibility, subject: pt1)

      viewpoint = Viewpoint.new(user: visibility.visible_to)

      expect(ProjectType.visible_to(viewpoint)).to eq [pt1]
    end
  end
end
