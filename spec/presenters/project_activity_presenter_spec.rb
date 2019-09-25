RSpec.describe ProjectActivityPresenter do
  it "presents a project activity" do
    activity = FactoryBot.create(:activity, name: "Activity name")
    FactoryBot.create(:project_activity, id: 111, activity: activity, order: 5)

    presented = described_class.present(ProjectActivity.last)
    expect(presented).to eq(id: 111, name: "Activity name")
  end

  it "orders by the order column" do
    FactoryBot.create(:project_activity, id: 111, order: 5)
    FactoryBot.create(:project_activity, id: 222, order: 6)
    FactoryBot.create(:project_activity, id: 333, order: 4)

    presented = described_class.present(ProjectActivity.all)
    expect(presented.map { |h| h.fetch(:id) }).to eq [333, 111, 222]
  end

  it "can present visible project activities only" do
    pa1  = FactoryBot.create(:project_activity, id: 111)
    _pa2 = FactoryBot.create(:project_activity, id: 222)

    visibility = FactoryBot.create(:visibility, subject: pa1)
    Viewpoint.current = Viewpoint.new(user: visibility.visible_to)

    presented = described_class.present(ProjectActivity.all, visible: true)
    expect(presented.map { |h| h.fetch(:id) }).to eq [111]
  end

  it "can present with source materials" do
    stub_const("DOCUMENTS_PATH", "/some/path")

    project_activity = FactoryBot.create(:project_activity)
    document = FactoryBot.create(:document, filename: "contract.pdf")

    FactoryBot.create(:source_material, subject: project_activity, document: document, page: 50)

    presented = described_class.present(project_activity, source_materials: true)
    expect(presented).to include(source_materials: [{
      page: 50,
      document: {
        path: "/some/path/contract.pdf",
      }
    }])
  end

  it "can present with project questions" do
    project_activity = FactoryBot.create(:project_activity)
    question = FactoryBot.create(:question, text: "Question text")
    FactoryBot.create(:project_question, id: 555, project_activity: project_activity, question: question)

    presented = described_class.present(project_activity, project_questions: true)
    expect(presented).to include(project_questions: [{ id: 555, text: "Question text" }])
  end

  it "can interpolate user names into project activity name" do
    activity = FactoryBot.create(:activity, name: "Activity about %{Role name}")
    project_activity = FactoryBot.create(:project_activity, activity: activity)

    user = FactoryBot.create(:user, name: "User name")
    role = FactoryBot.create(:role, name: "Role name")

    user_role = FactoryBot.create(:user_role, user: user, role: role)
    FactoryBot.create(:involvement, user: user, project_activity: project_activity)
    FactoryBot.create(:visibility, subject: project_activity.project, visible_to: user_role)

    presented = described_class.present(project_activity)
    expect(presented).to include(name: "Activity about User name")
  end

  it "passes the interpolation context down to other presenters" do
    allow(ProjectQuestionPresenter).to receive(:present) do |_, options|
      expect(options.fetch(:interpolation_context)).to be_present
    end

    project_activity = FactoryBot.create(:project_activity)
    described_class.present(project_activity, project_questions: true)
  end
end
