RSpec.describe ProjectCompletionQuestions do
  let(:project) { FactoryBot.create(:project) }
  let(:project_activity) { FactoryBot.create(:project_activity, project: project) }
  let(:question) { FactoryBot.create(:question) }
  let(:project_question) do
    FactoryBot.create(:project_question, project_activity: project_activity, question: question)
  end

  let(:user) { FactoryBot.create(:user) }
  let(:viewpoint) { Viewpoint.new(user: user) }

  before do
    FactoryBot.create(:completion_question, question: question, completion_value: "yes")

    FactoryBot.create(:visibility, subject: project_activity, visible_to: user)
    FactoryBot.create(:visibility, subject: project_question, visible_to: user)
  end

  it "returns visible project questions whose question has a completion question" do
    project_questions = described_class.for(viewpoint: viewpoint, project: project)
    expect(project_questions).to eq [project_question]
  end

  it "does not return project questions for other projects" do
    project_activity.update!(project: FactoryBot.create(:project))

    project_questions = described_class.for(viewpoint: viewpoint, project: project)
    expect(project_questions).to eq []
  end

  it "does not return projects questions that aren't visible" do
    Visibility.find_by!(subject: project_question).destroy

    project_questions = described_class.for(viewpoint: viewpoint, project: project)
    expect(project_questions).to eq []
  end

  it "does not return project questions for project activities that aren't visible" do
    Visibility.find_by!(subject: project_activity).destroy

    project_questions = described_class.for(viewpoint: viewpoint, project: project)
    expect(project_questions).to eq []
  end

  it "does not return project questions for question that do not have a completion question" do
    CompletionQuestion.last.destroy

    project_questions = described_class.for(viewpoint: viewpoint, project: project)
    expect(project_questions).to eq []
  end
end
