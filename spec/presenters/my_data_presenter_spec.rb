RSpec.describe MyDataPresenter do
  it "can present with projects" do
    FactoryBot.create(:project, id: 111, name: "Project name")

    presented = described_class.present(Project.all, projects: true)

    expect(presented).to include(
      projects: [
        hash_including(id: 111, name: "Project name"),
      ],
    )
  end
end
