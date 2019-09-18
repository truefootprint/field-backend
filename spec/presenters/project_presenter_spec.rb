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

    expect(presented).to include(project_activities: [
      { id: 555, name: "Activity name", state: "not_started" }
    ])
  end

  it "passes options through when presenting project activities" do
    project = FactoryBot.create(:project)
    project_activity = FactoryBot.create(:project_activity, project: project)
    FactoryBot.create(:project_question, subject: project_activity)

    presented = described_class.present(project, project_activities: { project_questions: true })
    presented_activity = presented.fetch(:project_activities).first

    expect(presented_activity).to have_key(:project_questions)
  end
end
