RSpec.describe Topic do
  describe "validations" do
    subject(:topic) { FactoryBot.build(:topic) }

    it "has a valid default factory" do
      expect(topic).to be_valid
    end

    it "requires a name" do
      topic.name = " "
      expect(topic).to be_invalid
    end

    it "requires a unique name" do
      FactoryBot.create(:topic, name: "Name")

      topic.name = "name"
      expect(topic).to be_invalid
    end
  end
end
