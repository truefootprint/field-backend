RSpec.describe "Follow up activities" do
  let(:user1) { FactoryBot.create(:user, name: "Azizi") }
  let(:user2) { FactoryBot.create(:user, name: "Nyah") }
  let(:user3) { FactoryBot.create(:user, name: "Tefo") }

  let(:farmer) { FactoryBot.create(:role, name: "farmer") }
  let(:monitor) { FactoryBot.create(:role, name: "monitor") }

  let(:activity) { FactoryBot.create(:activity, name: "Farming workshop", follow_up_activities: [follow_up]) }
  let(:follow_up) { FactoryBot.create(:activity, name: "%{farmer} applying knowledge") }

  let(:project_type) { FactoryBot.create(:project_type, name: "Farm training") }
  let(:project) { FactoryBot.create(:project) }

  let(:workshop) { FactoryBot.create(:project_activity, project: project, activity: activity) }

  before do
    allow(BasicAuth).to receive(:enabled?).and_return(false)

    topic = FactoryBot.create(:topic, name: "Rate %{farmer}'s farm")

    q1 = FactoryBot.create(:question, text: "How would you rate the workshop?")
    q2 = FactoryBot.create(:question, text: "Rate %{farmer}'s use of pesticide", topic: topic)

    FactoryBot.create(:project_question, project_activity: workshop, question: q1)
    FactoryBot.create(:default_question, activity: follow_up, question: q2)

    FactoryBot.create(:visibility, subject: follow_up, visible_to: monitor)

    FactoryBot.create(:visibility, subject: q1, visible_to: farmer)
    FactoryBot.create(:visibility, subject: q2, visible_to: monitor)

    [[user1, farmer], [user2, farmer], [user3, monitor]].each do |user, role|
      user_role = FactoryBot.create(:user_role, user: user, role: role)
      FactoryBot.create(:visibility, subject: project, visible_to: user_role)
    end
  end

  def register_for_workshop(name, role)
    post "/registrations", id: workshop.id, user_name: name, role_name: role
    expect(response.status).to eq(204)
  end

  def get_my_data(name, role)
    get "/my_data", user_name: name, role_name: role
    expect(response.status).to eq(200)
  end

  def project_activities
    parsed_json.fetch(:projects).first.fetch(:project_activities)
  end

  def applying_knowledge_questions
    project_activities.last.dig(:project_questions, :by_topic).first
  end

  scenario "creating follow up activities that are personalised to users" do
    get_my_data("Azizi", "farmer")
    expect(project_activities).to be_empty

    get_my_data("Nyah", "farmer")
    expect(project_activities).to be_empty

    get_my_data("Tefo", "monitor")
    expect(project_activities).to be_empty

    register_for_workshop("Azizi", "farmer")

    get_my_data("Azizi", "farmer")
    expect(project_activities.size).to eq(1)
    expect(project_activities.first.fetch(:name)).to eq("Farming workshop")

    get_my_data("Nyah", "farmer")
    expect(project_activities).to be_empty

    get_my_data("Tefo", "monitor")
    expect(project_activities.size).to eq(1)
    expect(project_activities.first.fetch(:name)).to eq("Azizi applying knowledge")

    register_for_workshop("Nyah", "farmer")

    get_my_data("Nyah", "farmer")
    expect(project_activities.size).to eq(1)
    expect(project_activities.first.fetch(:name)).to eq("Farming workshop")

    get_my_data("Tefo", "monitor")
    expect(project_activities.size).to eq(2)
    expect(project_activities.first.fetch(:name)).to eq("Azizi applying knowledge")
    expect(project_activities.second.fetch(:name)).to eq("Nyah applying knowledge")

    expect(applying_knowledge_questions.dig(:topic, :name)).to eq("Rate Nyah's farm")

    first_question = applying_knowledge_questions.fetch(:project_questions).first
    expect(first_question.fetch(:text)).to eq("Rate Nyah's use of pesticide")
  end
end
