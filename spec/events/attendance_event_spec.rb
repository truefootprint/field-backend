RSpec.describe AttendanceEvent do
  describe "#process" do
    let(:response) { FactoryBot.create(:response) }
    let(:activity) { FactoryBot.create(:activity) }

    let!(:event) do
      AttendanceEvent.new(response: response, follow_on_activity_id: activity.id)
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
    end
  end
end
