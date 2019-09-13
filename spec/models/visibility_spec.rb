RSpec.describe Visibility do
  describe "validations" do
    subject(:visibility) { FactoryBot.build(:visibility) }

    it "has a valid default factory" do
      expect(visibility).to be_valid
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
      visibilities = Visibility.union(user: users.first)

      expect(visibilities).to eq [visibility]
    end

    it "returns visibilities for the role" do
      visibility = FactoryBot.create(:visibility, subject: projects.first, visible_to: roles.first)
      visibilities = Visibility.union(role: roles.first)

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

      visibilities = Visibility.union(user: users.first, role: roles.first, user_roles: user_roles.first)

      expect(visibilities).to eq [v1, v2, v3]
    end

    it "looks up user_roles if not provided" do
      visibility = FactoryBot.create(:visibility, subject: projects.first, visible_to: user_roles.first)
      visibilities = Visibility.union(user: users.first, role: roles.first)

      expect(visibilities).to eq [visibility]
    end

    it "does not use nil values when building the scope" do
      scope = Visibility.union(user: nil, role: nil, user_roles: nil)
      expect(scope.to_sql).not_to match(/is null/i)

      scope = Visibility.union(user: nil, role: nil, user_roles: [])
      expect(scope.to_sql).not_to match(/is null/i)
    end
  end
end
