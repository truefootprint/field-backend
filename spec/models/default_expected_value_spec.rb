RSpec.describe DefaultExpectedValue do
  describe "validations" do
    subject(:default_expected_value) { FactoryBot.build(:default_expected_value) }

    it "has a valid default factory" do
      expect(default_expected_value).to be_valid
    end

    it "requires a value" do
      default_expected_value.value = " "
      expect(default_expected_value).to be_invalid
    end
  end

  describe ".for" do
    let(:question) { FactoryBot.create(:question) }
    let!(:default) { FactoryBot.create(:default_expected_value, question: question) }

    it "finds the default expected value by question" do
      record = described_class.for(question: question)
      expect(record).to eq(default)
    end

    context "when an activity is specified" do
      let(:activity) { FactoryBot.create(:activity) }

      it "finds the default specialised to the activity" do
        specialised = FactoryBot.create(
          :default_expected_value,
          activity: activity,
          question: question,
        )

        record = described_class.for(question: question, activity: activity)
        expect(record).to eq(specialised)
      end

      it "falls back to the default for the question" do
        record = described_class.for(question: question, activity: activity)
        expect(record).to eq(default)
      end
    end
  end
end
