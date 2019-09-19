RSpec.describe ProjectPresenter do
  it "presents a project" do
    project = FactoryBot.create(:project, id: 111, name: "Project name")
    expect(described_class.present(project)).to eq(id: 111, name: "Project name")
  end

  it "can present visible projects only" do
    p1  = FactoryBot.create(:project, id: 111)
    _p2 = FactoryBot.create(:project, id: 222)

    visibility = FactoryBot.create(:visibility, subject: p1)
    Viewpoint.current = Viewpoint.new(user: visibility.visible_to)

    presented = described_class.present(Project.all, visible: true)
    expect(presented.map { |h| h.fetch(:id) }).to eq [111]
  end

  it "can present with project activities" do
    project = FactoryBot.create(:project)
    activity = FactoryBot.create(:activity, name: "Activity name")
    FactoryBot.create(:project_activity, id: 555, project: project, activity: activity)

    presented = described_class.present(project, project_activities: true)
    expect(presented).to include(project_activities: [{ id: 555, name: "Activity name" }])
  end

  it "can present with the current project activity for a user" do
    viewpoint = Viewpoint.new
    project = FactoryBot.create(:project)

    expect(CurrentProjectActivity).to receive(:for)
      .with(viewpoint: viewpoint, project: project)

    described_class.present(project, current_project_activity: { for_viewpoint: viewpoint })
  end
end
