RSpec.describe ProjectPresenter do
  it "presents the project" do
    project = FactoryBot.create(:project, name: "Project name")

    presented = described_class.present(project)

    expect(presented).to eq(name: "Project name")
  end

  describe "variants" do
    subject(:project) { FactoryBot.create(:project, name: "Project name") }
    let(:activity) { FactoryBot.create(:activity, name: "Activity name") }

    before do
      FactoryBot.create(
        :project_activity,
        id: 555,
        project: project,
        activity: activity,
        state: "not_started",
      )
    end

    it "can present projects with project activities" do
      presenter = described_class::WithProjectActivities

      expect(presenter.present(project)).to include(
        project_activities: [{ id: 555, name: "Activity name", state: "not_started" }]
      )
    end

    it "can present projects with project activities and project questions" do
      presenter = described_class::WithProjectActivities::WithProjectQuestions
      presented = presenter.present(project)

      first = presented.fetch(:project_activities).first
      expect(first.fetch(:project_questions)).not_to be_nil
    end

    it "can present projects with projects activities and project questions by topic" do
      presenter = described_class::WithProjectActivities::WithProjectQuestions::ByTopic
      presented = presenter.present(project)

      first = presented.fetch(:project_activities).first
      expect(first.dig(:project_questions, :by_topic)).not_to be_nil
    end
  end
end
