RSpec.describe "Answering questions" do
  let!(:user) { FactoryBot.create(:user, name: "Test") }
  let!(:role) { FactoryBot.create(:role, name: "Test") }

  let(:auth) { { name: "Test", role: "Test" } }

  let(:project) { FactoryBot.create(:project) }

  let(:pa1) { FactoryBot.create(:project_activity, project: project) }
  let(:pa2) { FactoryBot.create(:project_activity, project: project) }

  let(:question) { FactoryBot.create(:question, text: "Is this activity finished?") }

  let(:pq1) { FactoryBot.create(:project_question, subject: pa1) }
  let(:pq2) { FactoryBot.create(:project_question, subject: pa1, question: question) }
  let(:pq3) { FactoryBot.create(:project_question, subject: pa2) }
  let(:pq4) { FactoryBot.create(:project_question, subject: pa2, question: question) }

  before do
    FactoryBot.create(:completion_question, question: question, completion_value: "yes")

    [project, pa1, pa2, pq1, pq2, pq3, pq4].each do |subject|
      FactoryBot.create(:visibility, subject: subject, visible_to: user)
    end
  end

  def current_project_activity
    parsed_json.fetch(:projects).first.fetch(:current_project_activity)
  end

  def completion_questions
    parsed_json.fetch(:projects).first.fetch(:completion_questions)
  end

  def question_responses
    parsed_json.fetch(:responses)
  end

  def post_action(action)
    post "/my_updates", auth.merge(actions: [action])
  end

  scenario "creating responses to questions that have been answered" do
    get "/my_data", auth
    expect(response.status).to eq(200)
    expect(current_project_activity).to eq(id: pa1.id, name: pa1.activity.name)
    expect(completion_questions).to eq [
      { project_question_id: pq2.id, completion_value: "yes" },
      { project_question_id: pq4.id, completion_value: "yes" },
    ]

    post_action(action: "AnswerQuestion", project_question_id: pq2.id, value: "yes")
    expect(response.status).to eq(201)

    get "/my_data", auth
    expect(response.status).to eq(200)
    expect(current_project_activity).to eq(id: pa2.id, name: pa2.activity.name)
    expect(question_responses).to eq [
      { project_question_id: pq2.id, value: "yes" },
    ]

    post_action(action: "AnswerQuestion", project_question_id: pq4.id, value: "yes")
    expect(response.status).to eq(201)

    get "/my_data", auth
    expect(current_project_activity).to be_nil
    expect(question_responses).to eq [
      { project_question_id: pq4.id, value: "yes" },
      { project_question_id: pq2.id, value: "yes" },
    ]
  end
end
