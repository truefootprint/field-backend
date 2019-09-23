RSpec.describe Participant do
  let(:project_activity) { FactoryBot.create(:project_activity) }
  let(:role) { FactoryBot.create(:role, name: "farmer") }
  let(:user_role) { FactoryBot.create(:user_role, role: role) }

  it "returns the user with the given role that has visibility of the project activity" do
    FactoryBot.create(:visibility, subject: project_activity, visible_to: user_role)

    user = Participant.find(project_activity, role)

    expect(user).to eq(user_role.user)
  end

  it "errors if more than one user has visibility of the project activity" do
    another_user_role = FactoryBot.create(:user_role, role: role)

    FactoryBot.create(:visibility, subject: project_activity, visible_to: user_role)
    FactoryBot.create(:visibility, subject: project_activity, visible_to: another_user_role)

    expect { Participant.find(project_activity, role) }
      .to raise_error(AmbiguousParticipantError, /more than one farmer is participating/i)
  end

  it "errors if no users have visibility of the project activity" do
    expect { Participant.find(project_activity, role) }
      .to raise_error(ActiveRecord::RecordNotFound, /could not find a farmer participating/i)
  end

  it "does not look beyond the user roles for the project activity" do
    FactoryBot.create(:visibility, subject: project_activity.activity, visible_to: user_role)

    FactoryBot.create(:visibility, subject: project_activity, visible_to: user_role.user)
    FactoryBot.create(:visibility, subject: project_activity, visible_to: user_role.role)

    expect { Participant.find(project_activity, role) }
      .to raise_error(ActiveRecord::RecordNotFound, /could not find a farmer participating/i)
  end
end
