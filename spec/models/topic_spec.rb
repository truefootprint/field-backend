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
  end

  describe ".visible" do
    it "returns topics visible from the current viewpoint" do
      topic1, _topic2 = FactoryBot.create_list(:topic, 2)
      visibility = FactoryBot.create(:visibility, subject: topic1)

      Viewpoint.current = Viewpoint.new(user: visibility.visible_to)

      expect(Topic.visible).to eq [topic1]
    end
  end
end
