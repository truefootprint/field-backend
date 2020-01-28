RSpec.describe Viewpoint do
  describe "#scope" do
    it "returns the visible items of a given class" do
      user = FactoryBot.create(:user)
      project1, _project2 =  FactoryBot.create_list(:project, 2)

      FactoryBot.create(:visibility, subject: project1, visible_to: user)

      viewpoint = Viewpoint.new(users: user)
      projects = viewpoint.scope(Project)

      expect(projects).to eq [project1]
    end
  end
end
