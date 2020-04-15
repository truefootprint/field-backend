RSpec.describe Template do
  describe ".for" do
    it "returns the template for the object" do
      project_type = FactoryBot.create(:project_type)
      activity = FactoryBot.create(:activity)
      question = FactoryBot.create(:free_text_question)

      template1 = described_class.for(project_type)
      template2 = described_class.for(activity)
      template3 = described_class.for(question)

      expect(template1).to be_a(described_class::ProjectType)
      expect(template2).to be_a(described_class::Activity)
      expect(template3).to be_a(described_class::Question)
    end
  end

  describe described_class::ProjectType do
    subject(:template) { described_class.new(project_type) }

    let(:programme) { FactoryBot.create(:programme) }
    let(:project_type) { FactoryBot.create(:project_type) }

    it "creates a project in the programme with the given name" do
      expect { subject.create_records(programme, "Project name") }
        .to change(Project, :count).by(1)

      project = Project.last

      expect(project.name).to eq("Project name")
      expect(project.project_type).to eq(project_type)
    end

    it "creates project roles for the project" do
      role1 = FactoryBot.create(:role)
      role2 = FactoryBot.create(:role)

      FactoryBot.create(:default_role, project_type: project_type, role: role1, order: 1)
      FactoryBot.create(:default_role, project_type: project_type, role: role2, order: 2)

      expect { subject.create_records(programme, "Project name") }
        .to change(ProjectRole, :count).by(2)

      project_role = ProjectRole.last

      expect(project_role.project).to eq(Project.last)
      expect(project_role.role).to eq(role2)
      expect(project_role.order).to eq(2)
    end

    it "create visibilities for the project" do
      role = FactoryBot.create(:role)

      FactoryBot.create(:default_role, project_type: project_type, role: role, order: 1)
      FactoryBot.create(:default_visibility, subject: project_type, role: role)

      expect { subject.create_records(programme, "Project name") }
        .to change(Visibility, :count).by(1)

      visibility = Visibility.last

      expect(visibility.subject).to eq(Project.last)
      expect(visibility.visible_to).to eq(ProjectRole.last)
    end

    it "uses the activity template to create project activities, questions, etc" do
      activity = FactoryBot.create(:activity)

      FactoryBot.create(:default_activity, project_type: project_type, activity: activity)
      FactoryBot.create(:default_question, activity: activity)

      expect { subject.create_records(programme, "Project name") }
        .to change(ProjectActivity, :count).by(1)
        .and change(ProjectQuestion, :count).by(1)
    end

    it "returns the created project" do
      project = subject.create_records(programme, "Project name")
      expect(project).to eq(Project.last)
    end
  end

  describe described_class::Activity do
    subject(:template) { described_class.new(activity) }

    let(:project) { FactoryBot.create(:project) }
    let(:activity) { FactoryBot.create(:activity) }

    let!(:default_activity) do
      FactoryBot.create(
        :default_activity,
        project_type: project.project_type,
        activity: activity,
        order: 5,
      )
    end

    it "creates a project activity for the project" do
      expect { subject.create_records(project) }
        .to change(ProjectActivity, :count).by(1)

      project_activity = ProjectActivity.last

      expect(project_activity.project).to eq(project)
      expect(project_activity.activity).to eq(activity)
    end

    it "sets the project activity's order from the default for the project type" do
      subject.create_records(project)

      expect(ProjectActivity.last.order).to eq(5)
    end

    it "sets the project activity's order to 1 if there is no default" do
      default_activity.destroy

      subject.create_records(project)

      expect(ProjectActivity.last.order).to eq(1)
    end

    it "create visibilities for the project activity" do
      role = FactoryBot.create(:role)

      FactoryBot.create(:project_role, project: project, role: role)
      FactoryBot.create(:default_visibility, subject: activity, role: role)

      expect { subject.create_records(project) }
        .to change(Visibility, :count).by(1)

      visibility = Visibility.last

      expect(visibility.subject).to eq(ProjectActivity.last)
      expect(visibility.visible_to).to eq(ProjectRole.last)
    end

    it "creates project questions for the project activity" do
      FactoryBot.create(:default_question, activity: activity)
      FactoryBot.create(:default_question, activity: activity)

      expect { subject.create_records(project) }
        .to change(ProjectQuestion, :count).by(2)

      project_activity = ProjectActivity.last
      project_question = ProjectQuestion.last

      expect(project_question.project_activity).to eq(project_activity)
    end

    it "uses the question template to create project questions, etc" do
      question = FactoryBot.create(:question)

      FactoryBot.create(:default_question, activity: activity)

      expect { subject.create_records(project) }
        .to change(ProjectQuestion, :count).by(1)
    end

    it "returns the created project activity" do
      project_activity = subject.create_records(project)
      expect(project_activity).to eq(ProjectActivity.last)
    end
  end

  describe described_class::Question do
    subject(:template) { described_class.new(question) }

    let(:question) { FactoryBot.create(:question) }
    let(:project_activity) { FactoryBot.create(:project_activity) }
    let(:activity) { project_activity.activity }

    it "creates a project question for the project activity" do
      expect { subject.create_records(project_activity) }
        .to change(ProjectQuestion, :count).by(1)

      project_question = ProjectQuestion.last

      expect(project_question.project_activity).to eq(project_activity)
      expect(project_question.question).to eq(question)
    end

    it "create visibilities for the project activity" do
      role = FactoryBot.create(:role)

      FactoryBot.create(:project_role, project: project_activity.project, role: role)
      FactoryBot.create(:default_visibility, subject: question, role: role)

      expect { subject.create_records(project_activity) }
        .to change(Visibility, :count).by(1)

      visibility = Visibility.last

      expect(visibility.subject).to eq(ProjectQuestion.last)
      expect(visibility.visible_to).to eq(ProjectRole.last)
    end

    it "creates expected values for the project questions" do
      unit = FactoryBot.create(:unit)

      FactoryBot.create(
        :default_expected_value,
        question: question,
        value: "yes",
        text: "It should be 'yes'",
        unit: unit,
      )

      expect { subject.create_records(project_activity) }
        .to change(ExpectedValue, :count).by(1)

      project_question = ProjectQuestion.last
      expected_value = ExpectedValue.last

      expect(expected_value.value).to eq("yes")
      expect(expected_value.text).to eq("It should be 'yes'")
      expect(expected_value.project_question).to eq(project_question)
      expect(expected_value.unit).to eq(unit)
    end

    it "uses the default expected value specialised to the activity if it exists" do
      FactoryBot.create(:default_expected_value, question: question, value: "yes")
      FactoryBot.create(:default_expected_value, question: question, activity: activity, value: "no")

      expect { subject.create_records(project_activity) }
        .to change(ExpectedValue, :count).by(1)

      project_question = ProjectQuestion.last
      expected_value = ExpectedValue.last

      expect(expected_value.value).to eq("no")
      expect(expected_value.project_question).to eq(project_question)
    end

    it "copies all translations from the default expected value to the expected value" do
      default_expected_value = FactoryBot.create(
        :default_expected_value,
        question: question,
        text_en: "english",
        text_fr: "french",
      )

      subject.create_records(project_activity)
      expected_value = ExpectedValue.last

      expect(expected_value.text_en).to eq("english")
      expect(expected_value.text_fr).to eq("french")
    end
  end
end
