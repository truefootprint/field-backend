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
end
