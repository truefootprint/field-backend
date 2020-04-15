RSpec.describe Viewpoint do
  describe "#scope" do
    it "returns the visible items of a given class" do
      project_role = FactoryBot.create(:project_role)
      project1, _project2 = FactoryBot.create_list(:project, 2)

      FactoryBot.create(:visibility, subject: project1, visible_to: project_role)

      viewpoint = Viewpoint.new(project_roles: project_role)
      projects = viewpoint.scope(Project)

      expect(projects).to eq [project1]
    end
  end

  describe ".for_user" do
    it "combines the visibility of the user and their project roles" do
      user = FactoryBot.create(:user)
      project_role = FactoryBot.create(:project_role)
      FactoryBot.create(:registration, user: user, project_role: project_role)

      question1, question2 = FactoryBot.create_list(:question, 2)

      FactoryBot.create(:visibility, subject: question1, visible_to: user)
      FactoryBot.create(:visibility, subject: question2, visible_to: project_role)

      viewpoint = Viewpoint.for_user(user)
      questions = viewpoint.scope(Question)

      expect(questions).to match_array [question1, question2]
    end
  end
end
