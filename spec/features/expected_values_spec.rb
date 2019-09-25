RSpec.describe "Expected values" do
  before do
    user = FactoryBot.create(:user, name: "Test")
    FactoryBot.create(:role, name: "Test")

    project = FactoryBot.create(:project)
    project_activity = FactoryBot.create(:project_activity, project: project)
    question = FactoryBot.create(:question, text: "How much pesticide was used?")
    project_question = FactoryBot.create(
      :project_question,
      project_activity: project_activity,
      question: question,
    )

    FactoryBot.create(:expected_value, project_question: project_question, value: "10 liters")

    [project, project_activity, project_question].each do |subject|
      FactoryBot.create(:visibility, subject: subject, visible_to: user)
    end
  end

  let(:auth) { { name: "Test", role: "Test" } }

  scenario "presenting the expected value for a question" do
    get "/my_data", auth

    first_project          = parsed_json.fetch(:projects).first
    first_project_activity = first_project.fetch(:project_activities).first
    first_topic            = first_project_activity.dig(:project_questions, :by_topic).first
    first_project_question = first_topic.fetch(:project_questions).first

    expect(first_project_question).to include(
      text: "How much pesticide was used?",
      expected_value: {
        value: "10 liters",
        source_materials: [],
      },
    )
  end
end
