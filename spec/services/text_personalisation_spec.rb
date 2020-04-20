RSpec.describe TextPersonalisation do
  let(:user) { FactoryBot.create(:user) }

  it "returns the user interface text if there is no personalisation" do
    FactoryBot.create(:user_interface_text, key: "key", value: "default text")

    expect(described_class.ordered_list(user)).to eq [
      { key: "key", value: "default text" }
    ]
  end

  it "returns the personalised text if there is personalisation" do
    ui_text = FactoryBot.create(:user_interface_text, key: "key", value: "default text")

    project = FactoryBot.create(:project)
    project_role = FactoryBot.create(:project_role, project: project)
    FactoryBot.create(:registration, user: user, project_role: project_role)

    FactoryBot.create(
      :personalised_text,
      user_interface_text: ui_text,
      project_role: project_role,
      value: "personalised text",
    )

    expect(described_class.ordered_list(user)).to eq [
      { key: "key", value: "personalised text", projects: [project.id] },
      { key: "key", value: "default text" }
    ]
  end

  it "groups projects together that have the same personalised text" do
    ui_text = FactoryBot.create(:user_interface_text, key: "key", value: "default text")

    projects = 3.times.map do
      project = FactoryBot.create(:project)
      project_role = FactoryBot.create(:project_role, project: project)
      FactoryBot.create(:registration, user: user, project_role: project_role)

      FactoryBot.create(
        :personalised_text,
        user_interface_text: ui_text,
        project_role: project_role,
        value: "the same personalised text",
      )

      project
    end

    expect(described_class.ordered_list(user)).to eq [
      { key: "key", value: "the same personalised text", projects: projects.map(&:id) },
      { key: "key", value: "default text" }
    ]
  end

  it "ignores personalised text that is the same as the default text" do
    ui_text = FactoryBot.create(:user_interface_text, key: "key", value: "default text")

    project = FactoryBot.create(:project)
    project_role = FactoryBot.create(:project_role, project: project)
    FactoryBot.create(:registration, user: user, project_role: project_role)

    FactoryBot.create(
      :personalised_text,
      user_interface_text: ui_text,
      project_role: project_role,
      value: "default text",
    )

    expect(described_class.ordered_list(user)).to eq [
      { key: "key", value: "default text" }
    ]
  end

  it "doesn't show personalised text for project roles the user isn't registered for" do
    ui_text = FactoryBot.create(:user_interface_text, key: "key", value: "default text")

    project = FactoryBot.create(:project)
    project_role = FactoryBot.create(:project_role, project: project)
    # Don't create a registration for the user.

    FactoryBot.create(
      :personalised_text,
      user_interface_text: ui_text,
      project_role: project_role,
      value: "personalised text",
    )

    expect(described_class.ordered_list(user)).to eq [
      { key: "key", value: "default text" }
    ]
  end
end
