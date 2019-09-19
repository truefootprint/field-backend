RSpec.describe CurrentProjectActivity do
  let(:project) { FactoryBot.create(:project) }

  let!(:project_activities) { [
    FactoryBot.create(:project_activity, project: project, order: 1),
    FactoryBot.create(:project_activity, project: project, order: 2),
    FactoryBot.create(:project_activity, project: project, order: 3),
  ] }

  let!(:project_questions) { [
    FactoryBot.create(:project_question, question: question, subject: project_activities.first),
    FactoryBot.create(:project_question, question: question, subject: project_activities.second),
    FactoryBot.create(:project_question, question: question, subject: project_activities.third),
  ] }

  let(:user) { FactoryBot.create(:user) }
  let(:viewpoint) { Viewpoint.new(user: user) }

  let(:question) { FactoryBot.create(:question, text: "Is this activity finished?") }

  before do
    FactoryBot.create(:completion_question, question: question, completion_value: "yes")

    [*project_activities, *project_questions].each do |subject|
      FactoryBot.create(:visibility, subject: subject, visible_to: user)
    end
  end

  it "returns the first project activity by order" do
    project_activities.first.update!(order: 5)
    expect(described_class.for(viewpoint, project)).to eq(project_activities.second)
  end

  it "advances to the next activity when the completion question is answered" do
    FactoryBot.create(:response, user: user, project_question: project_questions.first, value: "yes")
    expect(described_class.for(viewpoint, project)).to eq(project_activities.second)
  end

  it "does not advance to project activities that have no project questions" do
    project_questions.second.destroy

    FactoryBot.create(:response, user: user, project_question: project_questions.first, value: "yes")
    expect(described_class.for(viewpoint, project)).to eq(project_activities.third)
  end

  it "does not advance if the response value does not match the completion value" do
    FactoryBot.create(:response, user: user, project_question: project_questions.first, value: "no")
    expect(described_class.for(viewpoint, project)).to eq(project_activities.first)
  end

  it "does not advance if there is a newer response that does not match the compeltion value" do
    FactoryBot.create(:response, user: user, project_question: project_questions.first, value: "yes")
    FactoryBot.create(:response, user: user, project_question: project_questions.first, value: "no")

    expect(described_class.for(viewpoint, project)).to eq(project_activities.first)
  end

  it "does not advance to project activities that are not visible" do
    Visibility.find_by!(subject: project_activities.second).destroy

    FactoryBot.create(:response, user: user, project_question: project_questions.first, value: "yes")
    expect(described_class.for(viewpoint, project)).to eq(project_activities.third)
  end

  it "does not advance to project activities that have no visible project questions" do
    Visibility.find_by!(subject: project_questions.second).destroy

    FactoryBot.create(:response, user: user, project_question: project_questions.first, value: "yes")
    expect(described_class.for(viewpoint, project)).to eq(project_activities.third)
  end

  it "returns nil if there are no more project activities to advance to" do
    project_activities.second.destroy
    project_activities.third.destroy

    FactoryBot.create(:response, user: user, project_question: project_questions.first, value: "yes")
    expect(described_class.for(viewpoint, project)).to be_nil
  end

  it "advances correctly when there are other (non-completion) questions for the project activity" do
    project_question = FactoryBot.create(:project_question, subject: project_activities.first)
    FactoryBot.create(:visibility, subject: project_question, visible_to: user)

    FactoryBot.create(:response, user: user, project_question: project_questions.first, value: "yes")
    expect(described_class.for(viewpoint, project)).to eq(project_activities.second)
  end
end
