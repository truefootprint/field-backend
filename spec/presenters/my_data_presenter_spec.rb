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

  it "can present with the user" do
    user = FactoryBot.create(:user, id: 111, name: "User name")
    presented = described_class.present(Project.all, user: { for_user: user })

    expect(presented).to include(user: { id: 111, name: "User name" })
  end
end
