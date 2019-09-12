RSpec.describe ResponseTrigger do
  describe "validations" do
    subject(:response_trigger) { FactoryBot.build(:response_trigger) }

    it "has a valid default factory" do
      expect(response_trigger).to be_valid
    end

    it "requires a value" do
      response_trigger.value = " "
      expect(response_trigger).to be_invalid
    end

    it "requires an event_class" do
      response_trigger.event_class = " "
      expect(response_trigger).to be_invalid
    end
  end

  describe ".triggered_by" do
    it "returns triggers matching the responses question and value" do
      question1 = FactoryBot.create(:question)
      question2 = FactoryBot.create(:question)

      trigger1 = FactoryBot.create(:response_trigger, question: question1, value: "yes")
      trigger2 = FactoryBot.create(:response_trigger, question: question1, value: "no")
      trigger3 = FactoryBot.create(:response_trigger, question: question2, value: "yes")

      pquestion1 = FactoryBot.create(:project_question, question: question1)
      pquestion2 = FactoryBot.create(:project_question, question: question1)
      pquestion3 = FactoryBot.create(:project_question, question: question2)

      response1 = FactoryBot.create(:response, project_question: pquestion1, value: "yes")
      response2 = FactoryBot.create(:response, project_question: pquestion2, value: "no")
      response3 = FactoryBot.create(:response, project_question: pquestion3, value: "no")

      expect(ResponseTrigger.triggered_by(response1)).to eq [trigger1]
      expect(ResponseTrigger.triggered_by(response2)).to eq [trigger2]
      expect(ResponseTrigger.triggered_by(response3)).to eq []
    end
  end

  describe ".fire_events" do
    class TestEvent
      def self.fire(response:, foo:)
      end
    end

    before { allow(TestEvent).to receive(:fire) }

    let(:trigger) do
      FactoryBot.create(:response_trigger, value: "yes", event_class: "TestEvent", event_params: { foo: "bar" })
    end

    let(:response_matching_trigger) do
      project_question = FactoryBot.create(:project_question, question: trigger.question)

      FactoryBot.create(:response, project_question: project_question, value: "yes")
    end

    it "fires events triggered by the response" do
      ResponseTrigger.fire_events(response_matching_trigger)
      expect(TestEvent).to have_received(:fire)
    end

    it "does not fire events not triggered by the response" do
      ResponseTrigger.fire_events(FactoryBot.create(:response))
      expect(TestEvent).not_to have_received(:fire)
    end

    it "passes the response to the event" do
      ResponseTrigger.fire_events(response_matching_trigger)

      expect(TestEvent).to have_received(:fire).with(hash_including(
        response: response_matching_trigger,
      ))
    end

    it "passes the event_params to the event" do
      ResponseTrigger.fire_events(response_matching_trigger)

      expect(TestEvent).to have_received(:fire).with(hash_including(
        foo: "bar"
      ))
    end
  end

  describe "#event_params" do
    it "returns an empty hash if the trigger has no event_params" do
      trigger = FactoryBot.build(:response_trigger, event_params: nil)
      expect(trigger.event_params).to eq({})
    end

    it "deep symbolizes keys" do
      trigger = FactoryBot.build(:response_trigger, event_params: { "foo" => { "bar" => "baz" } })
      expect(trigger.event_params).to eq(foo: { bar: "baz" })
    end
  end
end
