RSpec.describe Registration::ProjectActivityActions do
  let(:project_type) { FactoryBot.create(:project_type) }
  let(:project) { FactoryBot.create(:project, project_type: project_type) }
  let(:activity) { FactoryBot.create(:activity, follow_up_activities: [follow_up]) }
  let(:follow_up) { FactoryBot.create(:activity) }

  let(:user) { FactoryBot.create(:user) }
  let(:viewpoint) { Viewpoint.new(users: user) }

  let!(:project_activity) do
    FactoryBot.create(:project_activity, project: project, activity: activity)
  end

  it "creates a project activity for each follow up activity" do
    expect { described_class.run(project_activity, viewpoint) }
      .to change(ProjectActivity, :count).by(1)

    expect(ProjectActivity.last.activity).to eq(follow_up)
  end

  it "creates an involvement for the main activity and each follow up activity" do
    expect { described_class.run(project_activity, viewpoint) }
      .to change(Involvement, :count).by(2)

    first, second = Involvement.last(2)

    expect(first.user).to eq(user)
    expect(second.user).to eq(user)

    expect(first.project_activity).to eq(project_activity)
    expect(second.project_activity).to eq(ProjectActivity.last)
  end
end
