RSpec.describe MyDataPresenter do
  it "can present with projects" do
    project = FactoryBot.create(:project, id: 111, name: "Project name")

    project_question = FactoryBot.create(:project_question, id: 222)
    response = FactoryBot.create(:response, project_question: project_question, value: "yes")

    presentable = { projects: [project], responses: [response] }
    options = { projects: true, responses: true }

    presented = described_class.present(presentable, options)

    expect(presented).to eq(
      projects: [{ id: 111, name: "Project name" }],
      responses: [{ project_question_id: 222, value: "yes" }]
    )
  end
end
