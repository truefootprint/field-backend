RSpec.describe Question do
  describe "validations" do
    subject(:question) { FactoryBot.build(:question) }

    it "has a valid default factory" do
      expect(question).to be_valid
    end

    it "requires text" do
      question.text = " "
      expect(question).to be_invalid
    end

    it "requires a known type" do
      question.type = "unknown"
      expect(question).to be_invalid
    end

    it "requires a known data type" do
      question.data_type = "unknown"
      expect(question).to be_invalid
    end

    it "must be unique per topic/text" do
      existing = FactoryBot.create(:question)

      question.text = existing.text
      expect(question).to be_valid

      question.topic = existing.topic
      expect(question).to be_invalid

      question.text = "Something else"
      expect(question).to be_valid
    end
  end
end
