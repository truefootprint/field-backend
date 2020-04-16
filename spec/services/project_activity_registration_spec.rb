RSpec.describe ProjectActivityRegistration do
  let(:project_type) { FactoryBot.create(:project_type) }
  let(:project) { FactoryBot.create(:project, project_type: project_type) }
  let(:activity) { FactoryBot.create(:activity, follow_up_activities: [follow_up]) }
  let(:follow_up) { FactoryBot.create(:activity) }

  let(:user) { FactoryBot.create(:user) }
  let(:role) { FactoryBot.create(:role, name: "monitor") }

  let!(:project_activity) do
    FactoryBot.create(:project_activity, project: project, activity: activity)
  end

  let!(:project_role) do
    FactoryBot.create(:project_role, project: project, role: role)
  end

  let!(:registration) do
    FactoryBot.create(:registration, user: user, project_role: project_role)
  end

  it "creates a project activity for each follow up activity" do
    expect { described_class.process(project_activity, user, role) }
      .to change(ProjectActivity, :count).by(1)

    expect(ProjectActivity.last.activity).to eq(follow_up)
  end

  it "creates a registration for the main activity and each follow up activity" do
    expect { described_class.process(project_activity, user, role) }
      .to change(Registration, :count).by(2)

    first, second = Registration.last(2)

    expect(first.user).to eq(user)
    expect(second.user).to eq(user)

    expect(first.project_activity).to eq(project_activity)
    expect(second.project_activity).to eq(ProjectActivity.last)
  end

  it "creates visibility of the main project activity for the user" do
    expect { described_class.process(project_activity, user, role) }
      .to change(Visibility, :count).by(1)

    visibility = Visibility.last

    expect(visibility.subject).to eq(project_activity)
    expect(visibility.visible_to).to eq(user)

    # We don't create visibility for of follow up project activities because
    # those questions might not be for the registering user. For example, the
    # monitor might visit the attendees farm and be asked questions about it.
    # If they should have visibility, we can add a default_visibility record.
  end

  it "does not allow the user to register if they do not have that role on the project" do
    another_role = FactoryBot.create(:role)
    another_project_role = FactoryBot.create(:project_role, project: project, role: another_role)

    registration.update!(project_role: another_project_role)

    expect { described_class.process(project_activity, user, role) }
      .to raise_error(/because they are not a monitor on project/)
  end
end
