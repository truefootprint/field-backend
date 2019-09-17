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

  describe "associations" do
    it "has project questions that are directly associated with the project" do
      project = FactoryBot.create(:project)
      direct = FactoryBot.create(:project_question, subject: project)

      project_activity = FactoryBot.create(:project_activity, project: project)
      indirect = FactoryBot.create(:project_question, subject: project_activity)

      expect(project.direct_project_questions).to eq [direct]
      expect(project.project_activity_questions).to eq [indirect]
      expect(project.all_project_questions).to eq [direct, indirect]
    end
  end

  describe ".visible" do
    it "returns projects visible from the current viewpoint" do
      project1, _project2 = FactoryBot.create_list(:project, 2)
      visibility = FactoryBot.create(:visibility, subject: project1)

      Viewpoint.current = Viewpoint.new(user: visibility.visible_to)

      expect(Project.visible).to eq [project1]
    end

    it "includes projects whose project_type is visible" do
      project1, _project2 = FactoryBot.create_list(:project, 2)
      visibility = FactoryBot.create(:visibility, subject: project1.project_type)

      Viewpoint.current = Viewpoint.new(user: visibility.visible_to)

      expect(Project.visible).to eq [project1]
    end
  end

  describe ".with_visible_project_activities" do
    it "filters the scope of projects and project_activities" do
      p1, _p2 = FactoryBot.create_list(:project, 2)
      pa1, _pa2 = FactoryBot.create_list(:project_activity, 2, project: p1)
      visibility = FactoryBot.create(:visibility, subject: pa1)

      Viewpoint.current = Viewpoint.new(user: visibility.visible_to)

      scope = Project.with_visible_project_activities

      expect(scope).to eq [p1]
      expect(scope.flat_map(&:project_activities)).to eq [pa1]
    end
  end

  describe ".with_visible_direct_project_questions" do
    it "filters the scope of projects and directly associated project_questions" do
      p1, _p2 = FactoryBot.create_list(:project, 2)
      pq1, _pq2 = FactoryBot.create_list(:project_question, 2, subject: p1)

      visibility = FactoryBot.create(:visibility, subject: pq1)

      Viewpoint.current = Viewpoint.new(user: visibility.visible_to)

      projects = Project.with_visible_direct_project_questions
      expect(projects).to eq [p1]

      project_questions = projects.flat_map(&:direct_project_questions)
      expect(project_questions).to eq [pq1]
    end
  end

  describe ".with_visible_project_activity_questions" do
    it "filters the scope of projects, project_activities and project_questions" do
      p1, _p2 = FactoryBot.create_list(:project, 2)
      pa1, _pa2 = FactoryBot.create_list(:project_activity, 2, project: p1)
      pq1, _pq2 = FactoryBot.create_list(:project_question, 2, subject: pa1)

      visibility = FactoryBot.create(:visibility, subject: pq1)

      Viewpoint.current = Viewpoint.new(user: visibility.visible_to)

      projects = Project.with_visible_project_activity_questions
      expect(projects).to eq [p1]

      project_activities = projects.flat_map(&:project_activities)
      expect(project_activities).to eq [pa1]

      project_questions = project_activities.flat_map(&:project_questions)
      expect(project_questions).to eq [pq1]
    end
  end
end
