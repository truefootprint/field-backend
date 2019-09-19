RSpec.describe MyDataPresenter do
  it "can present with projects and completion_questions" do
    project = FactoryBot.create(:project, id: 111, name: "Project name")

    question = FactoryBot.create(:question, id: 222)
    completion_question = FactoryBot.create(:completion_question, question: question)

    presentable = { projects: [project], completion_questions: [completion_question] }
    options = { projects: true, completion_questions: true }

    presented = described_class.present(presentable, options)

    expect(presented).to eq(
      projects: [{ id: 111, name: "Project name" }],
      completion_questions: [{ question_id: 222, completion_value: "yes" }],
    )
  end
end
