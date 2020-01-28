RSpec.describe Viewpoint do
  describe "#scope" do
    it "returns the visible items of a given class" do
      user_role = FactoryBot.create(:user_role)
      project1, _project2 = FactoryBot.create_list(:project, 2)

      FactoryBot.create(:visibility, subject: project1, visible_to: user_role)

      viewpoint = Viewpoint.new(user_roles: user_role)
      projects = viewpoint.scope(Project)

      expect(projects).to eq [project1]
    end
  end

  describe ".for_user" do
    it "combines the visibility of the user and their roles" do
      user = FactoryBot.create(:user)
      role = FactoryBot.create(:role)
      user_role = FactoryBot.create(:user_role, user: user, role: role)

      question1, question2, question3 = FactoryBot.create_list(:question, 3)

      FactoryBot.create(:visibility, subject: question1, visible_to: user)
      FactoryBot.create(:visibility, subject: question2, visible_to: role)
      FactoryBot.create(:visibility, subject: question3, visible_to: user_role)

      viewpoint = Viewpoint.for_user(user)
      questions = viewpoint.scope(Question)

      expect(questions).to match_array [question1, question2, question3]
    end
  end
end
