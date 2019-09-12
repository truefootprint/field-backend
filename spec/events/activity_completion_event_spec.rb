RSpec.describe ActivityCompletionEvent do
  describe "#process" do
    let(:response) { FactoryBot.create(:response) }
    let(:project_activity) { response.project_question.subject }

    subject(:event) { described_class.new(response: response) }

    it "sets the project activity's state to finished" do
      expect { event.process }
        .to change { project_activity.state }
        .from("not_started")
        .to("finished")
    end
  end
end
