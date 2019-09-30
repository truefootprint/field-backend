RSpec.describe DefaultActivityPresenter do
  it "presents a default activity" do
    default_activity = FactoryBot.create(:default_activity, id: 123, order: 5)
    expect(described_class.present(default_activity)).to eq(id: 123, order: 5)
  end

  it "can present with project types" do
    project_type = FactoryBot.create(:project_type, name: "Project type name")
    default_activity = FactoryBot.create(:default_activity, project_type: project_type)

    presented = described_class.present(default_activity, project_type: true)
    expect(presented.dig(:project_type, :name)).to eq("Project type name")
  end

  it "can present with activities" do
    activity = FactoryBot.create(:activity, name: "Activity name")
    default_activity = FactoryBot.create(:default_activity, activity: activity)

    presented = described_class.present(default_activity, activity: true)
    expect(presented.dig(:activity, :name)).to eq("Activity name")
  end
end
