RSpec.describe Template do
  describe ".for" do
    it "returns the template for the object" do
      project_type = FactoryBot.create(:project_type)
      activity = FactoryBot.create(:activity)

      template1 = described_class.for(project_type)
      template2 = described_class.for(activity)

      expect(template1).to be_a(described_class::ProjectType)
      expect(template2).to be_a(described_class::Activity)
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

    it "creates project questions for the project activity" do
      FactoryBot.create(:default_question, activity: activity)
      FactoryBot.create(:default_question, activity: activity)

      expect { subject.create_records(project) }
        .to change(ProjectQuestion, :count).by(2)

      project_activity = ProjectActivity.last
      project_question = ProjectQuestion.last

      expect(project_question.project_activity).to eq(project_activity)
    end

    it "creates expected values for the project questions" do
      default = FactoryBot.create(:default_question, activity: activity)
      FactoryBot.create(:default_expected_value, question: default.question, value: "yes")

      expect { subject.create_records(project) }
        .to change(ExpectedValue, :count).by(1)

      project_question = ProjectQuestion.last
      expected_value = ExpectedValue.last

      expect(expected_value.value).to eq("yes")
      expect(expected_value.project_question).to eq(project_question)
    end

    it "uses the default expected value specialised to the activity if it exists" do
      default = FactoryBot.create(:default_question, activity: activity)

      FactoryBot.create(:default_expected_value, question: default.question, value: "yes")
      FactoryBot.create(:default_expected_value, question: default.question, activity: activity, value: "no")

      expect { subject.create_records(project) }
        .to change(ExpectedValue, :count).by(1)

      project_question = ProjectQuestion.last
      expected_value = ExpectedValue.last

      expect(expected_value.value).to eq("no")
      expect(expected_value.project_question).to eq(project_question)
    end

    it "returns the created project activity" do
      project_activity = subject.create_records(project)
      expect(project_activity).to eq(ProjectActivity.last)
    end
  end
end
