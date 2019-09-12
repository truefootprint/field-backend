RSpec.describe AttendanceEvent do
  describe "#process" do
    let(:response) { FactoryBot.create(:response) }
    let(:activity) { FactoryBot.create(:activity) }

    let(:project_type) { response.project_type }

    let!(:event) do
      AttendanceEvent.new(response: response, follow_on_activity_id: activity.id)
    end

    let!(:default_activity) do
      FactoryBot.create(:default_activity, project_type: project_type, activity: activity)
    end

    it "creates a project activity for the follow-on activity" do
      expect { event.process }.to change(ProjectActivity, :count).by(1)

      project_activity = ProjectActivity.last

      expect(project_activity.project).to eq(response.project)
      expect(project_activity.activity).to eq(activity)
    end

    it "creates project questions based on the defaults for that activity" do
      FactoryBot.create(:default_question, activity: activity)
      FactoryBot.create(:default_question, activity: activity)

      expect { event.process }.to change(ProjectQuestion, :count).by(2)

      project_activity = ProjectActivity.last
      project_question = ProjectQuestion.last

      expect(project_question.subject).to eq(project_activity)
    end

    it "sets the project activity's order from the default for the project type" do
      expect { event.process }.to change(ProjectActivity, :count).by(1)

      project_activity = ProjectActivity.last

      expect(project_activity.order).to eq(default_activity.order)
    end
  end
end
