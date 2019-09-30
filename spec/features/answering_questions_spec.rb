RSpec.describe "Answering questions" do
  let!(:user) { FactoryBot.create(:user, name: "Test") }
  let!(:role) { FactoryBot.create(:role, name: "Test") }

  let(:auth) { { user_name: "Test", role_name: "Test" } }

  let(:project) { FactoryBot.create(:project) }

  let(:pa1) { FactoryBot.create(:project_activity, project: project) }
  let(:pa2) { FactoryBot.create(:project_activity, project: project) }

  let(:question) { FactoryBot.create(:question, text: "Is this activity finished?") }

  let(:pq1) { FactoryBot.create(:project_question, project_activity: pa1) }
  let(:pq2) { FactoryBot.create(:project_question, project_activity: pa1, question: question) }
  let(:pq3) { FactoryBot.create(:project_question, project_activity: pa2) }
  let(:pq4) { FactoryBot.create(:project_question, project_activity: pa2, question: question) }

  before do
    FactoryBot.create(:completion_question, question: question, completion_value: "yes")

    [project, pa1, pa2, pq1, pq2, pq3, pq4].each do |subject|
      FactoryBot.create(:visibility, subject: subject, visible_to: user)
    end
  end

  def current_project_activity
    all_projects.first.fetch(:current_project_activity)
  end

  def completion_question(pq)
    find_project_question(pq.id).fetch(:completion_question)
  end

  def responses(pq)
    find_project_question(pq.id).fetch(:responses)
  end

  def post_action(action)
    post "/my_updates", auth.merge(actions: [action])
  end

  scenario "creating responses to questions that have been answered" do
    get "/my_data", auth
    expect(response.status).to eq(200)
    expect(current_project_activity).to include(id: pa1.id, name: pa1.activity.name)
    expect(completion_question(pq2)).to include(completion_value: "yes")
    expect(completion_question(pq4)).to include(completion_value: "yes")

    post_action(action: "AnswerQuestion", project_question_id: pq2.id, value: "yes")
    expect(response.status).to eq(201)

    get "/my_data", auth
    expect(response.status).to eq(200)
    expect(current_project_activity).to include(id: pa2.id, name: pa2.activity.name)
    expect(responses(pq2)).to match [hash_including(value: "yes")]

    post_action(action: "AnswerQuestion", project_question_id: pq4.id, value: "yes")
    expect(response.status).to eq(201)

    get "/my_data", auth
    expect(current_project_activity).to be_nil
    expect(responses(pq4)).to match [hash_including(value: "yes")]
  end
end
