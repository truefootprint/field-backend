RSpec.describe ProjectActivity do
  describe "validations" do
    subject(:project_activity) { FactoryBot.build(:project_activity) }

    it "has a valid default factory" do
      expect(project_activity).to be_valid
    end

    it "requires an order" do
      project_activity.order = nil
      expect(project_activity).to be_invalid
    end
  end

  describe ".visible" do
    it "returns project_activities visible from the current viewpoint" do
      pa1, _pa2 = FactoryBot.create_list(:project_activity, 2)
      visibility = FactoryBot.create(:visibility, subject: pa1)

      Viewpoint.current = Viewpoint.new(user: visibility.visible_to)

      expect(ProjectActivity.visible).to eq [pa1]
    end

    it "includes project_activities whose activity is visible" do
      pa1, _pa2 = FactoryBot.create_list(:project_activity, 2)
      visibility = FactoryBot.create(:visibility, subject: pa1.activity)

      Viewpoint.current = Viewpoint.new(user: visibility.visible_to)

      expect(ProjectActivity.visible).to eq [pa1]
    end
  end
end
