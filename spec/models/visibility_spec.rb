RSpec.describe Visibility do
  describe "validations" do
    subject(:visibility) { FactoryBot.build(:visibility) }

    it "has a valid default factory" do
      expect(visibility).to be_valid
    end

    it "must be unique per subject/visible_to" do
      existing = FactoryBot.create(:visibility)

      visibility.subject = existing.subject
      expect(visibility).to be_valid

      visibility.visible_to = existing.visible_to
      expect(visibility).to be_invalid

      visibility.subject = FactoryBot.build(:project)
      expect(visibility).to be_valid
    end

    it "requires a known subject type" do
      visibility.subject_type = "unknown"
      expect(visibility).to be_invalid
    end

    it "requires a known visible to type" do
      visibility.visible_to_type = "unknown"
      expect(visibility).to be_invalid
    end

    it "requires project role that belongs to the same project as the subject" do
      visibility.visible_to = FactoryBot.create(:project_role)
      expect(visibility).to be_invalid

      visibility.visible_to = FactoryBot.create(:project_role, project: visibility.subject)
      expect(visibility).to be_valid
    end
  end

  describe ".subject_ids" do
    it "returns a select of the subject_ids for a given subject_type" do
      project = FactoryBot.create(:project)
      project_activity = FactoryBot.create(:project_activity)

      FactoryBot.create(:visibility, subject: project)
      FactoryBot.create(:visibility, subject: project_activity)

      selected = Visibility.subject_ids(Project)
      expect(selected.map(&:subject_id)).to eq [project.id]

      selected = Visibility.subject_ids(ProjectActivity)
      expect(selected.map(&:subject_id)).to eq [project_activity.id]

      selected = Visibility.none.subject_ids(Project)
      expect(selected.map(&:subject_id)).to eq []
    end
  end

  describe ".union" do
    let!(:users) { FactoryBot.create_list(:user, 2) }
    let!(:project_roles) { FactoryBot.create_list(:project_role, 2) }
    let!(:projects) { FactoryBot.create_list(:project, 3) }

    before do
      project_roles.first.update(project: projects.first)
      project_roles.second.update(project: projects.second)
    end

    it "returns visibilities for the user" do
      visibility = FactoryBot.create(:visibility, subject: projects.first, visible_to: users.first)
      visibilities = Visibility.union(users: users.first)

      expect(visibilities).to eq [visibility]
    end

    it "returns visibilities for the project_role" do
      visibility = FactoryBot.create(:visibility, subject: projects.first, visible_to: project_roles.first)
      visibilities = Visibility.union(project_roles: project_roles.first)

      expect(visibilities).to eq [visibility]
    end

    it "returns visibilities for the union of users and project_roles" do
      v1 = FactoryBot.create(:visibility, subject: projects.first, visible_to: project_roles.first)
      v2 = FactoryBot.create(:visibility, subject: projects.second, visible_to: project_roles.second)
      v3 = FactoryBot.create(:visibility, subject: projects.third, visible_to: users.first)

      visibilities = Visibility.union(users: users.first, project_roles: project_roles.first)

      expect(visibilities).to eq [v1, v3]
    end

    it "does not use nil values when building the scope" do
      scope = Visibility.union(users: nil, project_roles: nil)
      expect(scope.to_sql).not_to match(/is null/i)

      scope = Visibility.union(users: [], project_roles: [])
      expect(scope.to_sql).not_to match(/is null/i)
    end
  end
end
