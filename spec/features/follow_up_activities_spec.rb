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
    topic = FactoryBot.create(:topic, name: "Rate %{farmer}'s farm")

    q1 = FactoryBot.create(:question, text: "How would you rate the workshop?")
    q2 = FactoryBot.create(:question, text: "Rate %{farmer}'s use of pesticide", topic: topic)

    farmer_pr = FactoryBot.create(:project_role, project: project, role: farmer)
    monitor_pr = FactoryBot.create(:project_role, project: project, role: monitor)

    pq = FactoryBot.create(:project_question, project_activity: workshop, question: q1)

    # Make question 1 visible to all users with the farmer role for the project.
    FactoryBot.create(:visibility, subject: pq, visible_to: farmer_pr)

    # Make the follow up activity and question 2 visible to the monitors.
    FactoryBot.create(:default_question, activity: follow_up, question: q2)
    FactoryBot.create(:default_visibility, subject: q2, role: monitor)
    FactoryBot.create(:default_visibility, subject: follow_up, role: monitor)

    # Both project roles can see the project:
    FactoryBot.create(:visibility, subject: project, visible_to: farmer_pr)
    FactoryBot.create(:visibility, subject: project, visible_to: monitor_pr)

    [[user1, farmer_pr], [user2, farmer_pr], [user3, monitor_pr]].each do |user, project_role|
      FactoryBot.create(:registration, user: user, project_role: project_role)
    end
  end

  def register_for_workshop(name, role_name)
    authenticate_as(User.find_by!(name: name))
    post "/my_registrations", id: workshop.id, role: role_name
    expect(response.status).to eq(204)
  end

  def get_my_data(name)
    authenticate_as(User.find_by!(name: name))
    get "/my_data"
    expect(response.status).to eq(200)
  end

  def project_activities
    parsed_json.fetch(:projects).first.fetch(:project_activities)
  end

  def applying_knowledge_questions
    project_activities.last.dig(:project_questions, :by_topic).first
  end

  scenario "creating follow up activities that are personalised to users" do
    get_my_data("Azizi")
    expect(project_activities).to be_empty

    get_my_data("Nyah")
    expect(project_activities).to be_empty

    get_my_data("Tefo")
    expect(project_activities).to be_empty

    register_for_workshop("Azizi", "farmer")

    # Azizi can see the follow-up activity even though we don't direct any questions to
    # him in this scenario. This is a blanket rule but we might want to control this later.

    get_my_data("Azizi")
    expect(project_activities.size).to eq(2)
    expect(project_activities.first.fetch(:name)).to eq("Farming workshop")

    get_my_data("Nyah")
    expect(project_activities).to be_empty

    get_my_data("Tefo")
    expect(project_activities.size).to eq(1)
    expect(project_activities.first.fetch(:name)).to eq("Azizi applying knowledge")

    register_for_workshop("Nyah", "farmer")

    get_my_data("Nyah")
    expect(project_activities.size).to eq(2)
    expect(project_activities.first.fetch(:name)).to eq("Farming workshop")

    get_my_data("Tefo")
    expect(project_activities.size).to eq(2)
    expect(project_activities.first.fetch(:name)).to eq("Azizi applying knowledge")
    expect(project_activities.second.fetch(:name)).to eq("Nyah applying knowledge")

    expect(applying_knowledge_questions.dig(:topic, :name)).to eq("Rate Nyah's farm")

    first_question = applying_knowledge_questions.fetch(:project_questions).first
    expect(first_question.fetch(:text)).to eq("Rate Nyah's use of pesticide")
  end
end
