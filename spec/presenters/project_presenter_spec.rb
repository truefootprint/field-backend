RSpec.describe ProjectPresenter do
  it "presents a project" do
    project = FactoryBot.create(:project, id: 111, name: "Project name")
    expect(described_class.present(project)).to include(id: 111, name: "Project name")
  end

  it "can present visible projects only" do
    p1  = FactoryBot.create(:project, id: 111)
    _p2 = FactoryBot.create(:project, id: 222)

    visibility = FactoryBot.create(:visibility, subject: p1)
    Viewpoint.current = Viewpoint.new(user: visibility.visible_to)

    presented = described_class.present(Project.all, visible: true)
    expect(presented.map { |h| h.fetch(:id) }).to eq [111]
  end

  it "can present with the project summary" do
    project = FactoryBot.create(:project)
    FactoryBot.create(:project_summary, project: project, text: "Project summary text")

    presented = described_class.present(project, project_summary: true)
    expect(presented.dig(:project_summary, :text)).to eq("Project summary text")
  end

  it "can present with source materials" do
    project = FactoryBot.create(:project)
    document = FactoryBot.create(:document, filename: "contract.pdf")

    FactoryBot.create(:source_material, subject: project, document: document, page: 50)

    presented = described_class.present(project, source_materials: true)
    expect(presented).to include(source_materials: [hash_including(
      page: 50,
      document: hash_including(
        file: hash_including(
          url: a_string_matching("/contract.pdf"),
        ),
      ),
    )])
  end

  it "can present with the current project activity for a user" do
    viewpoint = Viewpoint.new
    project = FactoryBot.create(:project)

    expect(CurrentProjectActivity).to receive(:for)
      .with(viewpoint: viewpoint, project: project)

    described_class.present(project, current_project_activity: { for_viewpoint: viewpoint })
  end

  it "can present with project activities" do
    project = FactoryBot.create(:project)
    activity = FactoryBot.create(:activity, name: "Activity name")
    FactoryBot.create(:project_activity, id: 555, project: project, activity: activity)

    presented = described_class.present(project, project_activities: true)
    expect(presented).to include(project_activities: [
      hash_including(id: 555, name: "Activity name"),
    ])
  end

  it "can present with issues" do
    project = FactoryBot.create(:project)
    FactoryBot.create(:issue, subject: project, description: "Issue description", critical: true)

    presented = described_class.present(project, issues: true)
    expect(presented).to include(issues: [
      hash_including(description: "Issue description", critical: true),
    ])
  end
end
