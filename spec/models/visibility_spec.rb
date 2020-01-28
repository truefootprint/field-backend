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
    let!(:roles) { FactoryBot.create_list(:role, 2) }
    let!(:projects) { FactoryBot.create_list(:project, 4) }

    let!(:user_roles) { [
      FactoryBot.create(:user_role, user: users.first, role: roles.first),
      FactoryBot.create(:user_role, user: users.last, role: roles.last),
    ] }

    it "returns visibilities for the user" do
      visibility = FactoryBot.create(:visibility, subject: projects.first, visible_to: users.first)
      visibilities = Visibility.union(users: users.first)

      expect(visibilities).to eq [visibility]
    end

    it "returns visibilities for the role" do
      visibility = FactoryBot.create(:visibility, subject: projects.first, visible_to: roles.first)
      visibilities = Visibility.union(roles: roles.first)

      expect(visibilities).to eq [visibility]
    end

    it "returns visibilities for the user_role" do
      visibility = FactoryBot.create(:visibility, subject: projects.first, visible_to: user_roles.first)
      visibilities = Visibility.union(user_roles: user_roles)

      expect(visibilities).to eq [visibility]
    end

    it "returns visibilities for the union of users, roles and user_roles" do
      v1 = FactoryBot.create(:visibility, subject: projects.first, visible_to: users.first)
      v2 = FactoryBot.create(:visibility, subject: projects.second, visible_to: roles.first)
      v3 = FactoryBot.create(:visibility, subject: projects.third, visible_to: user_roles.first)
      v4 = FactoryBot.create(:visibility, subject: projects.fourth, visible_to: user_roles.last)

      visibilities = Visibility.union(users: users.first, roles: roles.first, user_roles: user_roles.first)

      expect(visibilities).to eq [v1, v2, v3]
    end

    it "does not use nil values when building the scope" do
      scope = Visibility.union(users: nil, roles: nil, user_roles: nil)
      expect(scope.to_sql).not_to match(/is null/i)

      scope = Visibility.union(users: [], roles: [], user_roles: [])
      expect(scope.to_sql).not_to match(/is null/i)
    end
  end
end
