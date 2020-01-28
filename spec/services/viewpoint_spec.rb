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

  describe ".for_user" do
    it "combines the visibility of the user and their roles" do
      user = FactoryBot.create(:user)
      role = FactoryBot.create(:role)
      user_role = FactoryBot.create(:user_role, user: user, role: role)

      project1, project2, project3 = FactoryBot.create_list(:project, 3)

      FactoryBot.create(:visibility, subject: project1, visible_to: user)
      FactoryBot.create(:visibility, subject: project2, visible_to: role)
      FactoryBot.create(:visibility, subject: project3, visible_to: user_role)

      viewpoint = Viewpoint.for_user(user)
      projects = viewpoint.scope(Project)

      expect(projects).to match_array [project1, project2, project3]
    end
  end
end
