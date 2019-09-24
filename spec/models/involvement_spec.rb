RSpec.describe Involvement do
  describe "validations" do
    subject(:involvement) { FactoryBot.build(:involvement) }

    it "has a valid default factory" do
      expect(involvement).to be_valid
    end
  end

  describe ".for_role" do
    it "returns involvements whose user has a user_role with visibility of the project activity" do
      inv1, _inv2 = FactoryBot.create_list(:involvement, 2)
      user_role = FactoryBot.create(:user_role, user: inv1.user)

      FactoryBot.create(
        :visibility,
        subject: inv1.project_activity,
        visible_to: user_role,
      )

      expect(Involvement.for_role(user_role.role)).to eq [inv1]
    end

    it "returns involvements whose visibility is at a project level instead of project activity" do
      inv1, _inv2 = FactoryBot.create_list(:involvement, 2)
      user_role = FactoryBot.create(:user_role, user: inv1.user)

      FactoryBot.create(
        :visibility,
        subject: inv1.project_activity.project,
        visible_to: user_role,
      )

      expect(Involvement.for_role(user_role.role)).to eq [inv1]
    end

    it "does not returns involvements for other users" do
      involvement = FactoryBot.create(:involvement)
      another_user = FactoryBot.create(:user)
      user_role = FactoryBot.create(:user_role, user: another_user)

      FactoryBot.create(
        :visibility,
        subject: involvement.project_activity,
        visible_to: user_role,
      )

      expect(Involvement.for_role(user_role.role)).to be_empty
    end
  end

  describe ".find_by_role!" do
    it "finds the involvement associated with the given role" do
      involvement = FactoryBot.create(:involvement)
      user_role = FactoryBot.create(:user_role, user: involvement.user)

      FactoryBot.create(
        :visibility,
        subject: involvement.project_activity,
        visible_to: user_role,
      )

      expect(Involvement.find_by_role!(user_role.role)).to eq(involvement)
    end

    it "errors if no involvements are found" do
      role = FactoryBot.create(:role)

      expect { Involvement.find_by_role!(role) }
        .to raise_error(ActiveRecord::RecordNotFound, /couldn't find involvement/i)
    end

    it "errors if more than one involvement is found" do
      role = FactoryBot.create(:role)
      project_activity = FactoryBot.create(:project_activity)

      2.times do
        user_role = FactoryBot.create(:user_role, role: role)
        FactoryBot.create(:involvement, project_activity: project_activity, user: user_role.user)
        FactoryBot.create(:visibility, subject: project_activity, visible_to: user_role)
      end

      expect { Involvement.find_by_role!(role) }
        .to raise_error(AmbiguousInvolvementError, /more than one involvement/i)
    end
  end
end
