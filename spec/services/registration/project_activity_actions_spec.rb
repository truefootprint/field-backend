RSpec.describe Registration::ProjectActivityActions do
  let(:project_type) { FactoryBot.create(:project_type) }
  let(:project) { FactoryBot.create(:project, project_type: project_type) }
  let(:activity) { FactoryBot.create(:activity, follow_up_activities: [follow_up]) }
  let(:follow_up) { FactoryBot.create(:activity) }

  let(:user) { FactoryBot.create(:user) }
  let(:viewpoint) { Viewpoint.new(user: user) }

  let!(:project_activity) do
    FactoryBot.create(:project_activity, project: project, activity: activity)
  end

  let!(:default_activity) do
    FactoryBot.create(:default_activity, project_type: project_type, activity: follow_up, order: 5)
  end

  it "creates a project activity for each follow up activity" do
    expect { described_class.run(project_activity, viewpoint) }
      .to change(ProjectActivity, :count).by(1)

    expect(ProjectActivity.last.activity).to eq(follow_up)
  end

  it "sets the project activity's order from the default for the project type" do
    described_class.run(project_activity, viewpoint)

    expect(ProjectActivity.last.order).to eq(5)
  end

  it "grants visibility of the follow up project activity" do
    expect { described_class.run(project_activity, viewpoint) }
      .to change(Visibility, :count).by(1)

    visibility = Visibility.last

    expect(visibility.subject).to eq(ProjectActivity.last)
    expect(visibility.visible_to).to eq(user)
  end

  it "creates project questions based on the defaults for the follow up activity" do
    FactoryBot.create(:default_question, activity: follow_up)
    FactoryBot.create(:default_question, activity: follow_up)

    expect { described_class.run(project_activity, viewpoint) }
      .to change(ProjectQuestion, :count).by(2)

    project_activity = ProjectActivity.last
    project_question = ProjectQuestion.last

    expect(project_question.subject).to eq(project_activity)
  end
end
