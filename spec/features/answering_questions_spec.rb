RSpec.describe "Answering questions" do
  let(:project_question) { FactoryBot.create(:project_question) }

  before do
    FactoryBot.create(:user, name: "Test") # TODO: authentication
    FactoryBot.create(:role, name: "Test")
  end

  let(:auth) { { name: "Test", role: "Test" } }

  scenario "creating responses to questions that have been answered" do
    actions = [
      { action: "AnswerQuestion", question_id: project_question.id, value: "yes" },
    ]

    post "/my_updates", { actions: actions }.merge(auth)

    expect(response.status).to eq(201)
  end
end
