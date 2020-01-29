RSpec.describe "Answering questions", type: :feature do
  let!(:user) { FactoryBot.create(:user, name: "Test") }
  let!(:role) { FactoryBot.create(:role, name: "Test") }

  let(:question) { FactoryBot.create(:question, text: "Is this activity finished?") }
  let(:project_question) { FactoryBot.create(:project_question, question: question) }
  let(:project_activity) { project_question.project_activity }
  let(:project) { project_activity.project }

  before do
    user_role = FactoryBot.create(:user_role, user: user, role: role)

    FactoryBot.create(:completion_question, question: question, completion_value: "yes")

    [project, project_activity, project_question].each do |subject|
      FactoryBot.create(:visibility, subject: subject, visible_to: user_role)
    end
  end

  def current_project_activity
    all_projects.first.fetch(:current_project_activity)
  end

  def responses(pq)
    find_project_question(pq.id).fetch(:responses)
  end

  def post_action(action)
    post "/my_updates", actions: [action]
  end

  def post_updates(updates)
    post "/my_updates", updates: updates
  end

  scenario "creating responses and updating them within the submission period" do
    authenticate_as(user)

    get "/my_data"
    expect(response.status).to eq(200)
    expect(current_project_activity).to include(id: project_activity.id)

    period_start = "2020-01-01T00:00:00.000Z"
    period_end = "2020-01-01T23:59:59.000Z"

    response1 = {
      created_at: "2020-01-01T12:00:00.000Z",
      updated_at: "2020-01-01T13:00:00.000Z",
      project_question_id: project_question.id,
      value: "yes",
    }

    post_updates([{ period_start: period_start, period_end: period_end, responses: [response1] }])
    expect(response.status).to eq(201)

    get "/my_data"
    expect(responses(project_question)).to match [hash_including(response1)]
    expect(current_project_activity).to be_nil

    # The response was updated by the user an hour later:
    response2 = response1.merge(value: "no", updated_at: "2020-01-01T14:00:00.000Z")
    post_updates([{ period_start: period_start, period_end: period_end, responses: [response2] }])
    expect(response.status).to eq(201)

    get "/my_data"
    expect(responses(project_question)).to match [hash_including(response2)]
    expect(current_project_activity).to include(id: project_activity.id)

    # It is now the next day:
    period_start = "2020-01-02T00:00:00.000Z"
    period_end = "2020-01-02T23:59:59.000Z"

    # A brand new response was submitted by the user:
    response3 = {
      created_at: "2020-01-02T12:00:00.000Z",
      updated_at: "2020-01-02T13:00:00.000Z",
      project_question_id: project_question.id,
      value: "yes",
    }

    post_updates([{ period_start: period_start, period_end: period_end, responses: [response3] }])
    expect(response.status).to eq(201)

    # A new response should be created, rather than updating the previous one:
    get "/my_data"
    expect(responses(project_question)).to match_array [
      hash_including(response2),
      hash_including(response3),
    ]
    expect(current_project_activity).to be_nil

    # The response was cleared out by the user an hour later:
    response4 = response3.merge(value: " ", updated_at: "2020-01-02T14:00:00.000Z")
    post_updates([{ period_start: period_start, period_end: period_end, responses: [response4] }])
    expect(response.status).to eq(201)

    get "/my_data"
    expect(responses(project_question)).to match [hash_including(response2)]
    expect(current_project_activity).to include(id: project_activity.id)
  end
end
