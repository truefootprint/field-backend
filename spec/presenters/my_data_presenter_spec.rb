RSpec.describe MyDataPresenter do
  it "can present with projects" do
    project = FactoryBot.create(:project, id: 111, name: "Project name")
    presented = described_class.present([project], projects: true)

    expect(presented).to eq(
      projects: [{ id: 111, name: "Project name" }],
    )
  end
end
